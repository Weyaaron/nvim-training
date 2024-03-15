local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")

local MoveStartOfLine = Task:new({ autocmd = "CursorMoved" })
MoveStartOfLine.__index = MoveStartOfLine

function MoveStartOfLine:setup()
	local function _inner_update()
		local lorem_ipsum = utility.lorem_ipsum_lines()
		utility.update_buffer_respecting_header(lorem_ipsum)
		utility.move_cursor_to_random_point()
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveStartOfLine:teardown(autocmd_callback_data)
	return vim.api.nvim_win_get_cursor(0)[2] == 0
end

function MoveStartOfLine:description()
	return "Move to the start of the current line"
end

return MoveStartOfLine
