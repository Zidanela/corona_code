--- Warp-type dot.

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
local sin = math.sin

-- Modules --
local audio = require("game.Audio")
local collision = require("game.Collision")
local common = lazy_require("editor.Common")
local dispatch_list = require("game.DispatchList")
local frames = require("game.Frames")
local fx = require("game.FX")
local links = lazy_require("editor.Links")
local markers = require("effect.Markers")
local tags = lazy_require("editor.Tags")
local utils = require("utils")

-- Corona globals --
local display = display
local transition = transition

-- Dot methods --
local Warp = {}

-- Layer used to draw hints --
local MarkersLayer

-- Move-between-warps transition --
local MoveParams = { transition = easing.inOutQuad }

-- Sounds played during warping --
local Sounds = audio.NewSoundGroup{ warp = "Warp.mp3", whiz = "WarpWhiz.mp3" }

-- Network of warps --
local WarpList

-- Default warp logic: no-op
local function DefWarp () end

-- Groups of warp transition handles, to allow cancelling --
local HandleGroups

-- Warp logic
local function DoWarp (warp, func)
	local target = WarpList[warp.m_to]

	if target then
		func = func or DefWarp

		func("move_prepare", warp, target)

		-- If there is no cargo, we're done. Otherwise, remove it and do warp logic.
		local items = warp.m_items

		if items then
			warp.m_items = nil

			-- Make a list for tracking transition handles and add it to a free slot.
			local hindex, handles = 1, {}

			while HandleGroups[hindex] do
				hindex = hindex + 1
			end

			HandleGroups[hindex] = handles

			-- Warp-in onComplete handler, which concludes the warp and does cleanup
			local function WarpIn_OC (object)
				if object.parent then
					func("move_done", warp, target)

					object:setMask(nil)

					-- Remove all trace of transitions.
					for i = 1, #handles do
						handles[i] = false
					end

					HandleGroups[hindex] = false
				end
			end

			-- Move onComplete handler, which segues into the warp-in stage of warping
			local function MoveParams_OC (object)
				if object.parent then
					for i, item in ipairs(items) do
						handles[i] = fx.WarpIn(item, i == 1 and WarpIn_OC)
					end

					func("move_done_moving", warp, target)

					Sounds:PlaySound("warp")
				end
			end

			-- Warp-out onComplete handler, which segues into the move stage of warping
			-- TODO: What if the warp is moving?
			local tx, ty = target.x, target.y

			local function WarpOut_OC (object)
				if object.parent then
					local dx, dy = object.x - tx, object.y - ty

					MoveParams.x = tx
					MoveParams.y = ty
					MoveParams.time = utils.QuantizeDistance("floor", dx, dy, 200, 500)
					MoveParams.onComplete = MoveParams_OC

					func("move_began_moving", warp, target)

					Sounds:PlaySound("whiz")

					-- We now want to track the single move transition. If we do need to
					-- cancel the warp, the logic only looks up to the first missing handle,
					-- so we can safely clear the list by setting the second entry false;
					-- the full array will be overwritten by warp-in transition handles in
					-- the next stage.
					handles[1], handles[2] = transition.to(object, MoveParams), false
				end
			end

			-- Kick off the warp-out transitions of each item. Since the transitions all
			-- finish at the same time, only the first needs an onComplete callback.
			for i, item in ipairs(items) do
				handles[i] = fx.WarpOut(item, i == 1 and WarpOut_OC)
			end

			Sounds:PlaySound("warp")

			return true
		end
	end
end

--- Dot method: warp acted on as dot of interest.
--
-- If the warp has a valid target, dispatches various event lists (cf. _func_ in @{Warp:Use})
-- with this warp and the target as arguments.
-- @see game.DispatchList.CallList
function Warp:ActOn ()
	if not DoWarp(self, dispatch_list.CallList) then
		-- Sound effect?
	end
end

---@param item Item to add to the warp's "cargo".
function Warp:AddItem (item)
	local items = self.m_items or {}

	items[#items + 1] = item

	self.m_items = items
end 

-- Physics body --
local Body = { radius = 25 }

--- Dot method: get property.
-- @string name Property name.
-- @return Property value, or **nil** if absent.
function Warp:GetProperty (name)
	if name == "body" then
		return Body
	elseif name == "touch_image" then
		return "Dot_Assets/WarpTouch.png"
	end
end

--- Dot method: reset warp state.
function Warp:Reset ()
	self.m_items = nil
end

-- Scale helper
local function Scale (warp, scale)
	warp.xScale = .5 * scale
	warp.yScale = .5 * scale
end

--- Dot method: update warp state.
function Warp:Update ()
	self.rotation = self.rotation - 150 * frames.DiffTime()

	Scale(self, 1 - sin(self.rotation / 30) * .05)
end

--- Manually triggers a warp, sending anything loaded by @{Warp:AddItem} through.
--
-- The cargo is emptied after use.
--
-- This is a no-op if the warp is missing a target.
-- @callable func As the warp progresses, this is called as
--   func(what, warp, target)
-- for the following values of _what_: **"move_prepare"** (if the cargo is empty, only this
-- is performed), **"move\_began\_moving"**, **"move\_done\_moving"**, **"move_done"**.
--
-- If absent, this is a no-op.
-- @treturn boolean The warp had cargo and a target?
function Warp:Use (func)
	return DoWarp(self, func) ~= nil
end

-- Add warp-OBJECT collision handler.
collision.AddHandler("warp", function(phase, warp, other, other_type)
	-- Player touched warp: signal it as the dot of interest.
	if other_type == "player" then
		dispatch_list.CallList("touching_dot", warp, phase == "began")

		-- Show or hide a hint between this warp and its target.
		local target = WarpList[warp.m_to]

		if target then
			if phase == "began" then
				warp.m_line = markers.PointFromTo(MarkersLayer, warp, target, 5, .5)
			else
				display.remove(warp.m_line)

				warp.m_line = nil
			end
		end

	-- Enemy touched warp: react.
	elseif other_type == "enemy" then
		other:ReactTo("touched_warp", warp, phase == "began")
	end
end)

-- Listen to events.
dispatch_list.AddToMultipleLists{
	-- Enter Level --
	enter_level = function(level)
		MarkersLayer = level.markers_layer
		HandleGroups = {}
		WarpList = {}
	end,

	-- Leave Level --
	leave_level = function()
		HandleGroups, MarkersLayer, WarpList = nil
	end,

	-- Pre-Reset --
	pre_reset = function()
		for i, hgroup in ipairs(HandleGroups) do
			if hgroup then
				for _, t in ipairs(hgroup) do
					if t then
						transition.cancel(t)
					else
						break
					end
				end

				HandleGroups[i] = false
			end
		end
	end
}

--
local function LinkWarp (warp1, warp2, sub1, _)
	if sub1 == "to" or (sub1 == "from" and not warp1.to) then
		warp1.to = warp2.uid
	end
end

-- Handler for warp-specific editor events, cf. game.Dots.EditorEvent
local function OnEditorEvent (what, arg1, arg2, arg3)
	-- Build --
	-- arg1: Level
	-- arg2: Instance
	-- arg3: Item to build
	if what == "build" then
		arg3.reciprocal_link = nil

	-- Enumerate Defaults --
	-- arg1: Defaults
	elseif what == "enum_defs" then
		arg1.reciprocal_link = true

	-- Enumerate Properties --
	-- arg1: Dialog
	-- arg2: Representative object
	elseif what == "enum_props" then
		arg1:AddLink{ text = "Link from source warp", rep = arg2, sub = "from", tags = "warp" }
		arg1:AddLink{ text = "Link to target warp", rep = arg2, sub = "to", tags = "warp" }
		arg1:AddCheckbox{ text = "Two-way link, if one is blank?", value_name = "reciprocal_link" }
		-- Polarity? Can be rotated?

	-- Get Tag --
	elseif what == "get_tag" then
		if not tags.Exists("warp") then
			tags.New("warp", {
				can_link = function(warp, other, wsub, osub)
					if wsub == "from" or wsub == "to" then
						if links.GetTag(other) ~= "warp" then
							return false, "Non-warp partner", true
						elseif osub ~= "from" and osub ~= "to" then
							return false, "Non-source / target sublink", true
						elseif wsub == osub then
							return false, "Source must pair with target", true
						elseif links.HasLinks(warp, wsub) then
							return false, "Source / target already paired"
						end
					end

					return true
				end,

				sub_links = { "from", "to" }
				-- ^^ ? for fire, etc...
			})
		end

		return "warp"

	-- Prep Link --
	elseif what == "prep_link" then
		return LinkWarp

	-- Verify --
	-- arg1: Verify block
	-- arg2: Dots
	-- arg3: Key
	elseif what == "verify" then
		local warp = arg2[arg3]
		local rep = common.GetBinding(warp, true)

		if links.HasLinks(rep, "to") or (links.HasLinks(rep, "from") and warp.reciprocal_link) then
			return
		else
			arg1[#arg1 + 1] = "Warp `" .. warp.name .. "` no target" .. (warp.recriprocal_link and " (or source to back-link)" or "")
		end
	end
end

-- Export the warp factory.
return function (group, info)
	if group == "editor_event" then
		return OnEditorEvent
	end

	local warp = display.newImage(group, "Dot_Assets/Warp.png")

	Scale(warp, 1)

	for k, v in pairs(Warp) do
		warp[k] = v
	end

	Sounds:Load()

	-- Add the warp to the list so it can be targeted.
	warp.m_to = info.to

	WarpList[info.uid] = warp

	return warp
end