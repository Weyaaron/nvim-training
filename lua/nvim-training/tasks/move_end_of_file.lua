local RandomCursorStart = require("nvim-training.tasks.random_cursor_start")
local MoveToEndOfFile = {}
MoveToEndOfFile.__index = MoveToEndOfFile

setmetatable(MoveToEndOfFile, { __index = RandomCursorStart })
MoveToEndOfFile.__metadata = {
	autocmd = "CursorMoved",
	desc = "Move to the end the file.",
	instructions = "Move to the end of the file.",
	tags = { "movement", "end", "file", "vertical" },
}
function MoveToEndOfFile:new()
	local base = RandomCursorStart:new()

	setmetatable(base, { __index = MoveToEndOfFile })
	return base
end

function MoveToEndOfFile:deactivate()
	return vim.api.nvim_win_get_cursor(0)[1] == vim.api.nvim_buf_line_count(0)
end

return MoveToEndOfFile
