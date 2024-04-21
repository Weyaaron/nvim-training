local Task = require("nvim-training.task")

local utility = require("nvim-training.utility")
local LuaTask = Task:new()
LuaTask.__index = LuaTask

function LuaTask:new()
	local base = Task:new()
	setmetatable(base, { __index = LuaTask })
	return base
end

function LuaTask:construct_optional_header_args()
	--This is used to turn the header in lua tasks into a block comment
	return { _prefix_ = "--[[", _suffix_ = "--]]" }
end

return LuaTask
