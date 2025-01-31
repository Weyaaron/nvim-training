local utility = require("nvim-training.utility")
local Move = require("nvim-training.tasks.move")
local user_config = require("nvim-training.user_config")
local tag_index = require("nvim-training.tag_index")

local MoveMatch = {}
MoveMatch.__index = MoveMatch
setmetatable(MoveMatch, { __index = Move })

MoveMatch.__metadata = {
	autocmd = "CursorMoved",
	desc = "Move to the current match.",
	instructions = "Move to the current match.",
	tags = utility.flatten({ Move.__metadata.tags, tag_index.match }),
}
function MoveMatch:new()
	local base = Move:new()
	setmetatable(base, { __index = MoveMatch })
	return base
end
function MoveMatch:activate()
	local function _inner_update()
		local left_bound = 25
		local right_bound = 30
		local line =
			utility.construct_line_with_bracket(utility.construct_random_bracket_pair(), left_bound, right_bound)
		utility.set_buffer_to_rectangle_with_line(line)

		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { cursor_pos[1], left_bound - 1 })
		self.target_text = line:sub(left_bound, right_bound)
		self.cursor_target = { cursor_pos[1], right_bound - 1 }

		utility.construct_highlight(self.cursor_target[1], self.cursor_target[2], 1)
	end
	vim.schedule_wrap(_inner_update)()
end

return MoveMatch
