local utility = require("nvim-training.utility")
local Yank = require("nvim-training.tasks.yank")

local YankInsideMatch = {}
YankInsideMatch.__index = YankInsideMatch
setmetatable(YankInsideMatch, { __index = Yank })

YankInsideMatch.metadata = {
	autocmd = "TextYankPost",
	desc = "Yank inside the current match.",
	instructions = "",
	tags = { "yank", "inside", "match" },
}
function YankInsideMatch:new()
	local base = Yank:new()
	setmetatable(base, { __index = YankInsideMatch })
	return base
end
function YankInsideMatch:activate()
	local function _inner_update()
		local left_bound = 25
		local right_bound = 30
		local line =
			utility.construct_line_with_bracket(utility.construct_random_bracket_pair(), left_bound, right_bound)
		utility.set_buffer_to_rectangle_with_line(line)

		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { cursor_pos[1], left_bound - 1 })
		self.target_text = line:sub(left_bound, right_bound)
		utility.construct_highlight(cursor_pos[1], left_bound, #self.target_text - 2)
	end

	vim.schedule_wrap(_inner_update)()
end

function YankInsideMatch:instructions()
	return "Yank inside the current match" .. utility.construct_register_description(self.target_register) .. "."
end

return YankInsideMatch
