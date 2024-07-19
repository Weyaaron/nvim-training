local TaskStartRandomCursor = require("nvim-training.tasks.task_random_cursor_start")

local MoveToStartOfFile = {}
MoveToStartOfFile.__index = MoveToStartOfFile

setmetatable(MoveToStartOfFile, { __index = TaskStartRandomCursor })
MoveToStartOfFile.__metadata =
	{ autocmd = "CursorMoved", desc = "Move to the start of the file.", instruction = "Move to the start of the file." }
function MoveToStartOfFile:new()
	local base = TaskStartRandomCursor:new()
	setmetatable(base, { __index = MoveToStartOfFile })
	return base
end

function MoveToStartOfFile:deactivate(autocmd_callback_data)
	return vim.api.nvim_win_get_cursor(0)[1] == 1
end

return MoveToStartOfFile
