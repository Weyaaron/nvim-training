local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")
local user_config = require("nvim-training.user_config")

local DeleteInsideMatch = Task:new()
DeleteInsideMatch.__index = DeleteInsideMatch

function DeleteInsideMatch:new()
	local base = Task:new()
	setmetatable(base, { __index = DeleteInsideMatch })
	base.autocmd = "TextChanged"
	self.line_length = 0

	local function _inner_update()
		utility.add_pair_and_place_cursor(user_config.bracket_pairs[1])
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		local current_line = utility.get_line(cursor_pos[1])
		base.middle_piece = utility.extract_text_in_brackets(current_line, user_config.bracket_pairs[1])
	end
	vim.schedule_wrap(_inner_update)()
	return base
end
function DeleteInsideMatch:teardown(autocmd_callback_data)
	local correct_register_content = vim.fn.getreg('""') == self.middle_piece
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local current_line = utility.get_line(cursor_pos[1])
	local text_inside_brackets = utility.extract_text_in_brackets(current_line, user_config.bracket_pairs[1])
	return #text_inside_brackets == 0 and correct_register_content
end
function DeleteInsideMatch:description()
	return "Delete inside the current bracket pair."
end

return DeleteInsideMatch
