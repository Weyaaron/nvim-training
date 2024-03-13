local utility = require("nvim-training.utility")
local current_config = require("nvim-training.current_config")
local Task = require("nvim-training.task")

local MoveEndOfLine = Task:new({ autocmd = "CursorMoved", jump_distance = 5 })
MoveEndOfLine.__index = MoveEndOfLine

function MoveEndOfLine:setup()
	local function _inner_update()
		local lorem_ipsum = utility.lorem_ipsum_lines(4)
		utility.update_buffer_respecting_header(lorem_ipsum)

		self.x_start = math.random(3) + current_config.header_length
		local y_start = math.random(2, 10)
		vim.api.nvim_win_set_cursor(0, { self.x_start, y_start })

		local lines = vim.api.nvim_buf_get_lines(0, self.x_start - 1, vim.api.nvim_buf_line_count(0), false)
		self.cursor_target = #lines[1]
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveEndOfLine:teardown(autocmd_callback_data)
	local cursor_position_y = vim.api.nvim_win_get_cursor(0)[2]

	print(cursor_position_y, self.cursor_target)
	return cursor_position_y + 1 == self.cursor_target
end

function MoveEndOfLine:description()
	return "Move to the end of the current line"
end

return MoveEndOfLine
