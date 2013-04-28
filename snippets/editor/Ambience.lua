--- Game ambience editing components.

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

	-- Background options...
		-- Graphic, function, etc.
		-- Picture regions?
		-- Music

-- Pick background pattern?
-- Song??? Non-pattern background???

-- BACKGROUND: full image, part of image, full image in zone, part of image in zone

-- Standard library imports --
local ipairs = ipairs
local lines = io.lines
local open = io.open

-- Modules --
local button = require("ui.Button")
local common = require("editor.Common")
local dispatch_list = require("game.DispatchList")
local lfs = require("lfs")
local utils = require("utils")

-- Corona globals --
local display = display
local audio = audio
local system = system
local timer = timer

-- Exports --
local M = {}

-- --
local Current, Offset, CurrentText

-- --
local Group

-- --
local PlayOrStop

-- --
local Songs

-- --
local Stream, StreamName

-- --
local WatchMusicFolder

--
local function CloseStream ()
	if Stream then
		audio.stop()
		audio.dispose(Stream)
	end

	Stream, StreamName = nil
end

--
local function SetCurrent (what)
	Current = what

	CurrentText.text = "Current music file: " .. (what or "NONE")

	CurrentText:setReferencePoint(display.BottomRightReferencePoint)

	CurrentText.x = Songs.x + Songs.width
	CurrentText.y = Songs.y + Songs.height + CurrentText.height
end

-- --
local Base = system.getInfo("platformName") == "Android" and system.DocumentsDirectory or system.ResourceDirectory
-- ^^ TODO: Documents -> Caches?

-- --
local Names

-- Helper to load or reload the music list
local function Reload ()
	Songs:deleteAllRows()

	-- Populate the song list, checking what's still around.
	Names = utils.EnumerateFiles("Music", { base = Base, exts = { ".mp3", ".ogg" } })

	local add_row = common.ListboxRowAdder()
	local current, offset, stream_found

	for i, name in ipairs(Names) do
		if name == Current then
			current = i
		end

		if name == Offset then
			offset = i
		end

		stream_found = stream_found or name == StreamName

		Songs:insertRow(add_row)
	end

	-- If the stream file was removed while playing, try to close the stream before any
	-- problems arise.
	if not stream_found then
		CloseStream()
	end

	-- Invalidate the current element, if its file was erased.
	if not current then
		SetCurrent(nil)
	end

	-- If the offset element is still there, scroll the listbox to it. Otherwise, fall
	-- back to the current element, if possible. Update as necessary.
	offset = offset or current

	if offset then
		Songs:scrollToIndex(offset, 0)
	end

	Offset = Names[offset]
end

--
local function SetText (button, text)
	button.parent[2].text = text
end

-- --
local OnDevice = system.getInfo("environment") == "device"

---
-- @pgroup view X
function M.Load (view)
	local w, h = display.contentWidth, display.contentHeight

	Group = display.newGroup()
	Songs = common.Listbox(Group, w - 350, 100, {
		-- --
		get_text = function(index)
			return Names[index]
		end,

		-- --
		press = function(index)
			Offset = Names[index]
		end
	})

	common.Frame(Songs, 255, 0, 0)

	PlayOrStop = button.Button(Group, nil, w - 410, h - 70, 120, 50, function(bgroup)
		local was_streaming = Stream

		CloseStream()

		if was_streaming then
			SetText(bgroup, "Play")
		elseif Offset then
			Stream = audio.loadStream("Music/" .. Offset)

			if Stream then
				StreamName = Offset

				audio.play(Stream, { fadein = 1500, loops = -1 })

				SetText(bgroup, "Stop")
			end
		end
	end)

	--
	CurrentText = display.newText(Group, "", 0, 0, native.systemFont, 24)

	SetCurrent(nil)

	button.Button(Group, nil, w - 280, h - 70, 120, 50, function()
		SetCurrent(Offset)
	end, "Set")

	button.Button(Group, nil, w - 150, h - 70, 120, 50, function()
		SetCurrent(nil)
	end, "Clear")

	-- TODO: Might need adjusting
	utils.AddDirectory("Music", Base)

	--
	if OnDevice then -- TODO: Make this handle non-Android intelligently too...
		--
		local ipath = system.pathForFile("MusicIndex.txt") -- TODO: Formalize in persistence?
		local ifile = ipath and open(ipath, "rt")

		if ifile then
			for name in ifile:lines() do
			--	if lfs.attributes(dpath .. name, "mode") ~= "file" then -- TODO: Compare some info to avoid copying?
				name = "Music/" .. name

				utils.CopyFile(name, nil, name, nil)
			--	end
			end

			ifile:close()
		end

	--
	else
		button.Button(Group, nil, w - 320, h - 140, 280, 50, function()
			local ifile = open(system.pathForFile("MusicIndex.txt"), "wt") -- TODO: Formalize in persistence?

			if ifile then
				for _, name in ipairs(Names) do
					ifile:write(name, "\n")
				end

				ifile:close()
			end
		end, "Bake index file")
	end

	--
	WatchMusicFolder = utils.WatchForFileModification("Music", function()
		if Group.isVisible then
			Reload()
		else
			Songs.is_consistent = false
		end
	end, Base)

	--
	Group.isVisible = false

	view:insert(Group)
end

---
-- @pgroup view X
function M.Enter (view)
	if not Songs.is_consistent then
		Reload()

		Songs.is_consistent = true
	end

	-- Sample music (until switch view or option)
	-- Background option, sample
	-- Picture option, sample
	SetText(PlayOrStop[2], "Play")

	Group.isVisible = true
end

---
function M.Exit ()
	CloseStream()

	Group.isVisible = false
end

---
function M.Unload ()
	timer.cancel(WatchMusicFolder)

	Songs:removeSelf()

	Choice, Current, CurrentText, Group, Names, PlayOrStop, Songs, WatchMusicFolder = nil
end

-- Listen to events.
dispatch_list.AddToMultipleLists{
	-- Build Level --
	build_level = function(level)
		-- ??
	end,

	-- Load Level WIP --
	load_level_wip = function(level)
		level.ambience.version = nil

		SetCurrent(level.ambience.music)
	end,

	-- Save Level WIP --
	save_level_wip = function(level)
		level.ambience = { version = 1, music = Current }

		-- Secondary scores?
		-- Persist on level reset?
	end,

	-- Verify Level WIP --
	verify_level_wip = function(verify)
		-- Ensure music exists?
		-- Could STILL fail later... :(
	end
}

-- Export the module.
return M