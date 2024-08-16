local utility = require("nvim-training.utility")
local Delete = require("nvim-training.tasks.delete")
local user_config = require("nvim-training.user_config")

local DeleteInsideMatch = {}
DeleteInsideMatch.__index = DeleteInsideMatch
setmetatable(DeleteInsideMatch, { __index = Delete })

DeleteInsideMatch.__metadata = {
	autocmd = "TextChanged",
	desc = "Delete inside the current match.",
	instructions = "Delete inside the current match.",
	tags = "deletion, match, inside, change",
}
function DeleteInsideMatch:new()
	local base = Delete:new()
	setmetatable(base, { __index = DeleteInsideMatch })
	self.line_length = 0
	return base
end
function DeleteInsideMatch:activate()
	local function _inner_update()
		local left_bound = 25
		local right_bound = 30
		local line = utility.construct_line_with_bracket(user_config.bracket_pairs[1], left_bound, right_bound)
		utility.set_buffer_to_rectangle_with_line(line)

		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { cursor_pos[1], left_bound - 1 })

		local current_line = utility.get_line(cursor_pos[1])
		self.target_text = utility.extract_text_in_brackets(current_line, user_config.bracket_pairs[1])
	end
	vim.schedule_wrap(_inner_update)()
end

return DeleteInsideMatch
