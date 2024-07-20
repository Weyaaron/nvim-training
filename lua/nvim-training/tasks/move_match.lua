local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")
local user_config = require("nvim-training.user_config")

local MoveMatch = {}
MoveMatch.__index = MoveMatch
--Todo: Rework these kinds of tasks to stay in the middle of the screen instead of jumping around like a madmen

setmetatable(MoveMatch, { __index = Task })

MoveMatch.__metadata =
	{ autocmd = "CursorMoved", desc = "Move to the current match.", instructions = "Move to the current match." }
function MoveMatch:new()
	local base = Task:new()
	setmetatable(base, { __index = MoveMatch })
	base.random_bracket_pair = user_config.bracket_pairs[math.random(#user_config.bracket_pairs)]
	return base
end
function MoveMatch:activate()
	local function _inner_update()
		utility.add_pair_and_place_cursor(self.random_bracket_pair)
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		local current_line = utility.get_line(cursor_pos[1])
		self.middle_piece = utility.extract_text_in_brackets(current_line, user_config.bracket_pairs[1])
	end
	vim.schedule_wrap(_inner_update)()
end
function MoveMatch:deactivate(autocmd_callback_data)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local current_line = utility.get_line(cursor_pos[1])
	local char_at_pos = current_line:sub(cursor_pos[2] + 1, cursor_pos[2] + 1)
	return char_at_pos == self.random_bracket_pair[1] or char_at_pos == self.random_bracket_pair[2]
end

return MoveMatch
