local utility = require("nvim-training.utility")
local current_config = require("nvim-training.current_config")
local Task = require("nvim-training.task")

local MoveStartOfLine = Task:new({ autocmd = "CursorMoved", jump_distance = 5 })
MoveStartOfLine.__index = MoveStartOfLine

function MoveStartOfLine:setup()
	local function _inner_update()
		local lorem_ipsum = utility.lorem_ipsum_lines(4)
		utility.update_buffer_respecting_header(lorem_ipsum)

		self.x_start = math.random(3) + current_config.header_length
		local y_start = math.random(10, 30)
		vim.api.nvim_win_set_cursor(0, { self.x_start, y_start })
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveStartOfLine:teardown(autocmd_callback_data)
	local cursor_position_y = vim.api.nvim_win_get_cursor(0)[2]
	return cursor_position_y == 0
end

function MoveStartOfLine:description()
	return "Move to the start of the current line"
end

return MoveStartOfLine
