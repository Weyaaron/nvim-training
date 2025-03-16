local Move = require("nvim-training.tasks.move")
local utility = require("nvim-training.utility")
local movements = require("nvim-training.movements")

local MoveEndOfLine = {}
MoveEndOfLine.__index = MoveEndOfLine
setmetatable(MoveEndOfLine, { __index = Move })
MoveEndOfLine.metadata = {
	autocmd = "CursorMoved",
	desc = "Move to the end of the current line.",
	instructions = "Move to the end of the current line.",
	tags = { "movement", "end", "line", "horizontal" },

	input_template = "$",
}
function MoveEndOfLine:new()
	local base = Move:new()
	setmetatable(base, { __index = MoveEndOfLine })
	return base
end
function MoveEndOfLine:activate()
	local function _inner_update()
		local random_line = utility.load_random_line()
		utility.set_buffer_to_rectangle_with_line(random_line)

		local cursor_pos = vim.api.nvim_win_get_cursor(0)

		local new_x_pos = movements.end_of_line(random_line, cursor_pos[2])
		self.cursor_target = { cursor_pos[1], new_x_pos }
		utility.construct_highlight(cursor_pos[1], self.cursor_target[2], 1)
	end
	vim.schedule_wrap(_inner_update)()
end

return MoveEndOfLine
