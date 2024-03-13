local Task = require("nvim-training.task")

local YankTask = Task:new({ autocmd = "TextYankPost" })
YankTask.__index = YankTask

function YankTask:teardown(autocmd_callback_data)
	local event_data = vim.deepcopy(vim.v.event)
	return event_data.regcontents[1] == self.target_text
end

return YankTask
