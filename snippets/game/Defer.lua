--- This module provides utilities for deferring and resolving certain operations.

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
local rawget = rawget
local type = type

-- Modules --
local lazy_tables = require("lazy_tables")

-- Exports --
local M = {}

--
function M.AddId (elem, key, id)
	local cur = elem[key]

	if cur then
		if type(cur) ~= "table" then
			cur = { cur }
			elem[key] = cur
		end

		cur[#cur + 1] = id
	else
		elem[key] = id
	end
end

-- --
local Deferred = lazy_tables.SubTablesOnDemand()

--
local function Add (dt, id, func, arg)
	dt[#dt + 1] = id
	dt[#dt + 1] = func
	dt[#dt + 1] = arg
end

--- DOCME
function M.Await (name, id, func, arg)
	arg = arg or false

	local dt = Deferred[name]

	if type(id) == "table" then
		for _, v in ipairs(id) do
			Add(dt, v, func, arg)
		end
	else
		Add(dt, id, func, arg)
	end
end

--- DOCME
function M.BindBroadcast (what)
	local list

	return function(func, arg)
		local curf = arg[what]

		if curf then
			if not list then
				list = { curf }

				arg[what] = function(arg1, arg2, ...)
					if arg1 == "n" then
						return #list
					elseif arg1 == "i" then
						return list[arg2]
					end

					for _, func in ipairs(list) do
						func(arg1, arg2, ...)
					end
				end
			end

			list[#list + 1] = func
		else
			arg[what] = func
		end
	end
end

--- DOCME
function M.Defer (name, item, id)
	if id then
		local dt = Deferred[name]

		dt[-id] = item
	end
end

--
local function AuxEvent (event, index)
	if not index then
		return event and 0, event
	elseif index > 0 then
		return index - 1, event("i", index)
	end
end

--- DOCME
function M.IterEvents (event)
	return AuxEvent, event, event and event("n")
end

--- DOCME
function M.Reset (name)
	Deferred[name] = nil
end

-- MERP
function M.Resolve (name)
	local dt = rawget(Deferred, name)

	for i = 1, #(dt or ""), 3 do
		local id, func, arg = dt[i], dt[i + 1], dt[i + 2]

		func(dt[-id], arg)
	end

	M.Reset(name)
end

-- Export the module.
return M