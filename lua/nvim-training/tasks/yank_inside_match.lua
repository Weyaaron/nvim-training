local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")
local user_config = require("nvim-training.user_config")

local YankInsideMatch = Task:new()
YankInsideMatch.__index = YankInsideMatch

function YankInsideMatch:new()
	local base = Task:new()
	setmetatable(base, { __index = YankInsideMatch })
	base.autocmd = "TextYankPost"
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
function YankInsideMatch:teardown(autocmd_callback_data)
	local register_content = vim.fn.getreg('""')
	return register_content == self.middle_piece
end
function YankInsideMatch:description()
	return "Yank inside the current match."
end

return YankInsideMatch
