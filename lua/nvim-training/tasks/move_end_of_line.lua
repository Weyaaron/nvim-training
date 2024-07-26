local utility = require("nvim-training.utility")
local Move = require("nvim-training.tasks.move")
local movements = require("nvim-training.movements")

local MoveEndOfLine = {}
MoveEndOfLine.__index = MoveEndOfLine
setmetatable(MoveEndOfLine, { __index = Move })
MoveEndOfLine.__metadata = {
	autocmd = "CursorMoved",
	desc = "Move to the end of the current line.",
	instructions = "Move to the end of the current line.",
	tags = "movement, end, line, horizontal",
}
function MoveEndOfLine:new()
	local base = Move:new()
	setmetatable(base, { __index = MoveEndOfLine })
	return base
end
function MoveEndOfLine:activate()
	local function _inner_update()
		utility.set_buffer_to_rectangle_and_place_cursor_randomly()

		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		self.cursor_target = movements.end_of_line()

		utility.create_highlight(cursor_pos[1] - 1, self.cursor_target[2], 1)
	end
	vim.schedule_wrap(_inner_update)()
end

return MoveEndOfLine
