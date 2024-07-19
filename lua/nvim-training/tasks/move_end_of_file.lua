local TaskStartRandomCursor = require("nvim-training.tasks.task_random_cursor_start")
local MoveToEndOfFile = {}
MoveToEndOfFile.__index = MoveToEndOfFile

setmetatable(MoveToEndOfFile, { __index = TaskStartRandomCursor })
MoveToEndOfFile.__metadata =
	{ autocmd = "CursorMoved", desc = "Move to the end the file.", instruction = "Move to the end of the file." }
function MoveToEndOfFile:new()
	local base = TaskStartRandomCursor:new()

	setmetatable(base, { __index = MoveToEndOfFile })
	return base
end

function MoveToEndOfFile:deactivate(autocmd_callback_data)
	return vim.api.nvim_win_get_cursor(0)[1] == vim.api.nvim_buf_line_count(0)
end

return MoveToEndOfFile
