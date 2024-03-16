local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")

local MoveStartOfLine = Task:new({ autocmd = "CursorMoved" })
MoveStartOfLine.__index = MoveStartOfLine

function MoveStartOfLine:setup()
	local function _inner_update()
		utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()

		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		self.highlight = utility.create_highlight(cursor_pos[1] - 1, 0, 1)
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveStartOfLine:teardown(autocmd_callback_data)
	utility.clear_highlight(self.highlight)
	return vim.api.nvim_win_get_cursor(0)[2] == 0
end

function MoveStartOfLine:description()
	return "Move to the start of the current line"
end

return MoveStartOfLine
