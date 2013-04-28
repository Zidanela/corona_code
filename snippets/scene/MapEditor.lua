--- Map editor scene.
--
-- In this scene, users can edit and test "work in progress" levels, and build levels
-- into a form loadable by @{game.LevelMap.LoadLevel}.
--
-- The scene expects event.params == { main = { _cols_, _rows_ }**[**, is_loading = _name_
-- **]** }, where _cols_ and _rows_ are the tile-wise size of the level. When loading a
-- level, you must also provide _name_, which corresponds to the _name_ argument in the
-- level-related functions in @{game.Persistence} (_wip_ == **true**).
--
-- The editor is broken up into several "views", each isolating specific features of the
-- level. The bulk of the editor logic is implemented in these views' modules, with common
-- building blocks in @{editor.Common} and @{editor.Dialog}. View-agnostic operations are
-- found in @{editor.Ops} and are used to implement various core behaviors in this scene.
--
-- TODO: Mention enter_menus; also load_level_wip, save_level_wip, level_wip_opened, level_wip_closed events...

--
-- Permission is hereby granted, free of charge, to any person obtaining
-- a copy of this software and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, sublicense, and/or sell copies of the Software, and to
-- permit persons to whom the Software is furnished to do so, subject to
-- the following conditions:
--
-- The above copyright notice and this permission notice shall be
-- included in all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
-- IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
-- CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
-- TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
-- SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--
-- [ MIT license: http://www.opensource.org/licenses/mit-license.php ]
--

-- Standard library imports --
local ipairs = ipairs
local pairs = pairs

-- Modules --
local button = require("ui.Button")
local common = require("editor.Common")
local dispatch_list = require("game.DispatchList")
local events = require("editor.Events")
local grid = require("editor.Grid")
local iterators = require("iterators")
local ops = require("editor.Ops")
local persistence = require("game.Persistence")
local scenes = require("game.Scenes")
local timers = require("game.Timers")

-- Corona globals --
local display = display
local native = native

-- Corona modules --
local storyboard = require("storyboard")

-- Map editor scene --
local Scene = storyboard.newScene()

-- Current editor view --
local Current

-- View switching and related FSM logic
local function SetCurrent (view)
	if Current then
		Current.Exit(Scene.view)
	end

	Current = view

	if Current then
		Current.Enter(Scene.view)
	end
end

-- List of editor views --
local EditorView = {}

-- Names of editor views --
local Names = { "General", "Ambience", "Dots", "EventBlocks", "Tiles", "Settings" }

-- Tab buttons to choose views... --
local TabButtons = {}

for i, name in ipairs(Names) do
	TabButtons[#TabButtons + 1] = {
		label = name,

		onPress = function(event)
			SetCurrent(EditorView[name])

			return true
		end
	}
end

-- ... and the tabs themselves --
local Tabs

-- Different ways of handling quits --
local AlertChoices = { "Save and quit", "Discard", "Cancel" }

-- Scene listener: handles quit requests
local function Listen (what)
	if what == "message:wants_to_go_back" then
		-- Everything saved / nothing to save: quit.
		if not common.IsDirty() then
			ops.Quit()

		-- Unsaved changes: ask for confirmation to quit.
		else
			native.showAlert("You have unsaved changes!", "Do you really want to quit?", AlertChoices, function(event)
				if event.action == "clicked" and event.index ~= 3 then
					if event.index == 1 then
						ops.Save()
					end

					ops.Quit()
				end
			end)
		end
	end
end

-- Non-level state to restore when returning from a test --
local RestoreState

-- Name used to store working version of level (WIP and build) in the database --
local TestLevelName = "?TEST?"

-- Enter Scene --
function Scene:enterScene (event)
	scenes.SetListenFunc(Listen)

	-- We may enter the scene one of two ways: from the editor setup menu, in which case
	-- we use the provided scene parameters; or returning from a test, in which case we
	-- must reconstruct the editor state from various information we left behind.
	local params

	if storyboard.getPrevious() == "scene.Level" then
		dispatch_list.CallList("enter_menus")

		local exists, data = persistence.LevelExists(TestLevelName, true)

		-- TODO: Doesn't exist? (Database failure?)

		params = persistence.Decode(data)

		params.is_loading = RestoreState.level_name
	else
		params = event.params
	end

	-- Load sidebar buttons for editor operations.
	for i, func, text in iterators.ArgsByN(2,
		scenes.WantsToGoBack, "Back",

		-- Test the level --
		function()
			local restore = { was_dirty = common.IsDirty(), common.GetDims() }

			ops.Verify()

			if common.IsVerified() then
				restore.level_name = ops.GetLevelName()

				-- The user may not want to save the changes being tested, so we introduce
				-- an intermediate test level instead. The working version of the level may
				-- already be saved, however, in which case the upcoming save will be a no-
				-- op unless we manually dirty the level.
				common.Dirty()

				-- We save the test level: as a WIP, so we can restore up to our most recent
				-- changes; and as a build, which will be what we test. Both are loaded into
				-- the database, in order to take advantage of the loading machinery, under
				-- a reserved name (this will overwrite any existing entries). The levels are
				-- marked as temporary so they don't show up in enumerations.
				ops.SetTemp(true)
				ops.SetLevelName(TestLevelName)
				ops.Save()
				ops.Build()
				ops.SetTemp(false)

				timers.Defer(function()
					local exists, data = persistence.LevelExists(TestLevelName)

					if exists then
						RestoreState = restore

						scenes.GoToScene{ name = "scene.Level", params = data, no_effect = true }
					else
						native.showAlert("Error!", "Failed to launch test level")

						-- Fix any inconsistent editor state.
						if restore.was_dirty then
							common.Dirty()
						end

						ops.SetLevelName(restore.level_name)
					end
				end)
			end
		end, "Test",

		-- Build a game-ready version of the level --
		ops.Build, "Build",

		-- Verify the game-ready integrity of the level --
		ops.Verify, "Verify",

		-- Save the working version of the level --
		ops.Save, "Save"
	) do
		local button = button.Button(self.view, nil, 10, display.contentHeight - i * 65 - 5, 100, 50, func, text)

		-- Add some buttons to a list for e.g. graying out.
		if text == "Save" or text == "Verify" then
			common.AddButton(text, button)
		end
	end

	-- Load the view-switching tabs.
	Tabs = common.TabBar(self.view, TabButtons)

	-- Initialize systems.
	common.Init(params.main[1], params.main[2])
	grid.Init(self.view)
	ops.Init(self.view)

	-- Install the views.
	for _, view in pairs(EditorView) do
		view.Load(self.view)
	end

	-- If we are loading a level, set the working name and dispatch a load event. If we
	-- tested a new level, it may not have a name yet, but in that case a restore state
	-- tells us our pre-test WIP is available to reload. Usually the editor state should
	-- not be dirty after a load.
	if params.is_loading or RestoreState then
		ops.SetLevelName(params.is_loading)

		dispatch_list.CallList("load_level_wip", params)

		events.ResolveLinks(params, false)
		common.Undirty()
	end

	-- Trigger the default view.
	Tabs:setSelected(1, true)

	-- If the state was dirty before a test, then re-dirty it.
	if RestoreState and RestoreState.was_dirty then
		common.Dirty()
	end

	-- Remove evidence of any test and alert listeners that the WIP is opened.
	RestoreState = nil

	dispatch_list.CallList("level_wip_opened")
end

Scene:addEventListener("enterScene")

-- Exit Scene --
function Scene:exitScene ()
	scenes.SetListenFunc(nil)

	SetCurrent(nil)

	for _, view in pairs(EditorView) do
		view.Unload()
	end

	ops.CleanUp()
	grid.CleanUp()
	common.CleanUp()

	Tabs:removeSelf()

	for i = self.view.numChildren, 1, -1 do
		self.view:remove(i)
	end

	dispatch_list.CallList("level_wip_closed")
end

Scene:addEventListener("exitScene")

-- Finally, install the editor views.
for _, name in ipairs(Names) do
	EditorView[name] = require("editor." .. name)
end

return Scene