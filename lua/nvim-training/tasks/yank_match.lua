local Yank = require("nvim-training.tasks.yank")
local utility = require("nvim-training.utility")
local tag_index = require("nvim-training.tag_index")

local YankMatch = {}
YankMatch.__index = YankMatch
setmetatable(YankMatch, { __index = Yank })

YankMatch.metadata = {
	autocmd = "TextYankPost",
	desc = "Yank the current match.",
	instructions = "",
	tags = utility.flatten({ tag_index.yank, tag_index.match, "register" }),
	input_template = "<target_register>y%",
}
function YankMatch:new()
	local base = Yank:new()
	setmetatable(base, { __index = YankMatch })
	return base
end
function YankMatch:activate()
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

function YankMatch:instructions()
	return "Yank the current match" .. utility.construct_register_description(self.target_register) .. "."
end

return YankMatch
