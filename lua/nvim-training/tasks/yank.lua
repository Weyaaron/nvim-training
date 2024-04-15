local Task = require("nvim-training.task")

local YankTask = {}
YankTask.__index = YankTask

function YankTask:new()
	local base = Task:new()
	setmetatable(base, { __index = YankTask })
	return base
end
function YankTask:teardown(autocmd_callback_data)
	-- local event_data = vim.deepcopy(vim.v.event)
	-- print(self.target_text, "--", event_data.regcontents[1])
	local clipboard_content = vim.fn.getreg('"')

	local yank_success = self.target_text == clipboard_content
	return yank_success
	-- return event_data.regcontents[1] == self.target_text
end

return YankTask
