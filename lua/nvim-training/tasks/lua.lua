local Task = require("nvim-training.task")
--Rework into not being a parent
local Lua = {}
Lua.__index = Lua
setmetatable(Lua, { __index = Task })

function Lua:new()
	local base = Task:new()
	setmetatable(base, { __index = Lua })
	return base
end

function Lua:construct_optional_header_args()
	--This is used to turn the header in lua tasks into a block comment
	return { _prefix_ = "--[[", _suffix_ = "--]]" }
end

return Lua
