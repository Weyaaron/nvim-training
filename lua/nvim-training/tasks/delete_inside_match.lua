local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")
local user_config = require("nvim-training.user_config")

local DeleteInsideMatch = {}
DeleteInsideMatch.__index = DeleteInsideMatch
setmetatable(DeleteInsideMatch, { __index = Task })

DeleteInsideMatch.__metadata = {
	autocmd = "TextChanged",
	desc = "Delete inside the current bracket pair.",
	instructions = "Delete inside the current bracket pair.",
	tags = "deletion, match, inside,",
}
function DeleteInsideMatch:new()
	local base = Task:new()
	setmetatable(base, { __index = DeleteInsideMatch })
	self.line_length = 0
	return base
end
function DeleteInsideMatch:activate()
	local function _inner_update()
		utility.add_pair_and_place_cursor(user_config.bracket_pairs[1])
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		local current_line = utility.get_line(cursor_pos[1])
		self.middle_piece = utility.extract_text_in_brackets(current_line, user_config.bracket_pairs[1])
	end
	vim.schedule_wrap(_inner_update)()
end
function DeleteInsideMatch:deactivate(autocmd_callback_data)
	local correct_register_content = vim.fn.getreg('""') == self.middle_piece
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local current_line = utility.get_line(cursor_pos[1])
	local text_inside_brackets = utility.extract_text_in_brackets(current_line, user_config.bracket_pairs[1])
	return #text_inside_brackets == 0 and correct_register_content
end

return DeleteInsideMatch
