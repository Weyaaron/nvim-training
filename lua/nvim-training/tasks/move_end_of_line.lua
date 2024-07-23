local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")

local MoveEndOfLine = {}
MoveEndOfLine.__index = MoveEndOfLine
setmetatable(MoveEndOfLine, { __index = Task })
MoveEndOfLine.__metadata = {
	autocmd = "CursorMoved",
	desc = "Move to the end of the current line.",
	instructions = "Move to the end of the current line.",
	tags = "move, end, line, horizontal",
}
function MoveEndOfLine:new()
	local base = Task:new()
	setmetatable(base, { __index = MoveEndOfLine })
	return base
end
function MoveEndOfLine:activate()
	local function _inner_update()
		utility.set_buffer_to_rectangle_and_place_cursor_randomly()
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		local lines = vim.api.nvim_buf_get_lines(0, cursor_pos[1] - 1, cursor_pos[1], false)

		self.cursor_target = #lines[1] - 1
		if self.cursor_target == cursor_pos[2] then
			--This prevents starting in the last column
			vim.api.nvim_win_set_cursor(0, { cursor_pos[1], cursor_pos[2] - 1 })
		end

		utility.create_highlight(cursor_pos[1] - 1, self.cursor_target, 1)
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveEndOfLine:deactivate(autocmd_callback_data)
	return vim.api.nvim_win_get_cursor(0)[2] == self.cursor_target
end

return MoveEndOfLine
