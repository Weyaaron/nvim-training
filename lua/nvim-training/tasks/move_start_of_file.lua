local RandomCursorStart = require("nvim-training.tasks.random_cursor_start")

local MoveToStartOfFile = {}
MoveToStartOfFile.__index = MoveToStartOfFile

setmetatable(MoveToStartOfFile, { __index = RandomCursorStart })
MoveToStartOfFile.__metadata = {
	autocmd = "CursorMoved",
	desc = "Move to the start of the file.",
	instructions = "Move to the start of the file.",
	tags = { "start", "file", "vertical" },
}
function MoveToStartOfFile:new()
	local base = RandomCursorStart:new()
	setmetatable(base, { __index = MoveToStartOfFile })
	return base
end

function MoveToStartOfFile:deactivate()
	return vim.api.nvim_win_get_cursor(0)[1] == 1
end

return MoveToStartOfFile
