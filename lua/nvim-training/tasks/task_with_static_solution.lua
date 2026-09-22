local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local StaticSolutionTask = {}

StaticSolutionTask.__index = StaticSolutionTask
setmetatable(StaticSolutionTask, { __index = Task })
StaticSolutionTask.metadata = { autocmd = "", desc = "", instructions = "", tags = { "static" } }

function StaticSolutionTask:new()
	local base = Task:new()
	setmetatable(base, StaticSolutionTask)
	base.target_text = ""
	return base
end
function StaticSolutionTask:deactivate()
	utility.update_debug_state({ target = self.target_text, actual_value = self:read_register() })
	return self.target_text == self:read_register()
end

return StaticSolutionTask
