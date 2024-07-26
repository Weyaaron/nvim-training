local utility = require("nvim-training.utility")
local Yank = require("nvim-training.tasks.yank")
local user_config = require("nvim-training.user_config")

local YankInsideMatch = {}
YankInsideMatch.__index = YankInsideMatch

setmetatable(YankInsideMatch, { __index = Yank })
YankInsideMatch.__metadata = {
	autocmd = "TextYankPost",
	desc = "Yank inside the current match.",
	instructions = "Yank inside the current match.",
	tags = "yank, inside, match",
}
function YankInsideMatch:new()
	local base = Yank:new()
	setmetatable(base, { __index = YankInsideMatch })
	return base
end
function YankInsideMatch:activate()
	local function _inner_update()
		utility.add_pair_and_place_cursor(user_config.bracket_pairs[1])
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		local current_line = utility.get_line(cursor_pos[1])
		self.target_text = utility.extract_text_in_brackets(current_line, user_config.bracket_pairs[1])
	end
	vim.schedule_wrap(_inner_update)()
end

return YankInsideMatch
