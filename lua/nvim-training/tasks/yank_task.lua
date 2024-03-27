local Task = require("nvim-training.task")

local YankTask = {}
YankTask.__index = YankTask

function YankTask:new()
	local base = Task:new()
	setmetatable(base, { __index = YankTask })
	return base
end
function YankTask:teardown(autocmd_callback_data)
	local event_data = vim.deepcopy(vim.v.event)
	-- print(self.target_text, "--", event_data.regcontents[1])
	return event_data.regcontents[1] == self.target_text
end

return YankTask
