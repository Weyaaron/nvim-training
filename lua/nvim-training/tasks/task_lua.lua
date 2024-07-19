local Task = require("nvim-training.task")

local TaskLua = {}
TaskLua.__index = TaskLua

setmetatable(TaskLua, { __index = Task })
function TaskLua:new()
	local base = Task:new()
	setmetatable(base, { __index = TaskLua })
	return base
end

function TaskLua:construct_optional_header_args()
	--This is used to turn the header in lua tasks into a block comment
	return { _prefix_ = "--[[", _suffix_ = "--]]" }
end

return TaskLua
