local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")

local MoveToEndOfFile = {}
MoveToEndOfFile.__index = MoveToEndOfFile

function MoveToEndOfFile:new()
	local base = Task:new()

	setmetatable(base, { __index = MoveToEndOfFile })
	self.autocmd = "CursorMoved"
	local function _inner_update()
		utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()
	end
	vim.schedule_wrap(_inner_update)()
	return self
end

function MoveToEndOfFile:teardown(autocmd_callback_data)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)[1] == vim.api.nvim_buf_line_count(0)
end

function MoveToEndOfFile:description()
	return "Move to the top of the file."
end

return MoveToEndOfFile
