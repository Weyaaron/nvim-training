local Task = require("nvim-training.task")

local utility = require("nvim-training.utility")
local YankTask = Task:new()
YankTask.__index = YankTask

function YankTask:new()
	local base = Task:new()
	setmetatable(base, { __index = YankTask })
	return base
end
function YankTask:teardown(autocmd_callback_data)
	utility.clear_all_our_highlights()
	local register = self.chosen_register or ""
	local register_content = vim.fn.getreg('"' .. register)

	local yank_success = self.target_text == register_content
	return yank_success
end

return YankTask
