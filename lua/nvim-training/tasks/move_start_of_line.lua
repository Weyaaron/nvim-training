local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")

local MoveStartOfLine = {}
MoveStartOfLine.metadata = {
	autocmd = "CursorMoved",
	desc = "Move to the start of the current line.",
	instructions = "Move to the start of the current line.",
	tags = { "start", "line", "movement" },
	input_template = "0",
}

setmetatable(MoveStartOfLine, { __index = Task })
MoveStartOfLine.__index = MoveStartOfLine
function MoveStartOfLine:new()
	local base = Task:new()
	setmetatable(base, { __index = MoveStartOfLine })
	return base
end
function MoveStartOfLine:activate()
	local function _inner_update()
		local random_line = utility.load_random_line()
		utility.set_buffer_to_rectangle_with_line(random_line)

		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		if cursor_pos[2] == 0 then
			--This prevents starting in the first column
			vim.api.nvim_win_set_cursor(0, { cursor_pos[1], 1 })
		end
		utility.construct_highlight(cursor_pos[1], 0, 1)
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveStartOfLine:deactivate()
	return vim.api.nvim_win_get_cursor(0)[2] == 0
end

return MoveStartOfLine
