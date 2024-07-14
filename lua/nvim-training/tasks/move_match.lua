local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")
local user_config = require("nvim-training.user_config")

local MoveMatch = Task:new()
MoveMatch.__index = MoveMatch

function MoveMatch:new()
	local base = Task:new()
	setmetatable(base, { __index = MoveMatch })
	base.autocmd = "CursorMoved"
	self.line_length = 0
	base.random_bracket_pair = user_config.bracket_pairs[math.random(#user_config.bracket_pairs)]

	local function _inner_update()
		utility.add_pair_and_place_cursor(base.random_bracket_pair)
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		local current_line = utility.get_line(cursor_pos[1])
		base.middle_piece = utility.extract_text_in_brackets(current_line, user_config.bracket_pairs[1])
	end
	vim.schedule_wrap(_inner_update)()
	return base
end
function MoveMatch:teardown(autocmd_callback_data)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local current_line = utility.get_line(cursor_pos[1])
	local char_at_pos = current_line:sub(cursor_pos[2] + 1, cursor_pos[2] + 1)
	return char_at_pos == self.random_bracket_pair[1] or char_at_pos == self.random_bracket_pair[2]
end
function MoveMatch:description()
	return "Move to the current match."
end

return MoveMatch
