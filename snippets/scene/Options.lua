--- Options scene.

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

-- Modules --
local button = require("ui.Button")
local DEBUG = require("DEBUG")
local persistence = require("game.Persistence")
local scenes = require("game.Scenes")

-- Corona modules --
local storyboard = require("storyboard")

-- Options scene --
local Scene = storyboard.newScene()

-- Create Scene --
function Scene:createScene ()
	button.Button(self.view, nil, 20, 20, 200, 50, scenes.WantsToGoBack, "Go Back")
	button.Button(self.view, nil, 20, 90, 200, 50, persistence.Wipe, "Wipe data")

	-- Populate with debug options, if available.
	if DEBUG then
		DEBUG("options", self.view)
	end
end

Scene:addEventListener("createScene")

-- Enter Scene --
function Scene:enterScene ()
	scenes.SetListenFunc_GoBack()
end

Scene:addEventListener("enterScene")

-- Exit Scene --
function Scene:exitScene ()
	scenes.SetListenFunc(nil)
end

Scene:addEventListener("exitScene")

return Scene