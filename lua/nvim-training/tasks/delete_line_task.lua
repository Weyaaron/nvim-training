local utility = require("nvim-training.utility")
local current_config = require("nvim-training.current_config")
local Task = require("nvim-training.task")

local DeleteLineTask = Task:new({ autocmd = "TextChanged" })
DeleteLineTask.__index = DeleteLineTask

function DeleteLineTask:setup()
	local function _inner_update()
		local lorem_ipsum = utility.lorem_ipsum_lines(4)
		utility.update_buffer_respecting_header(lorem_ipsum)

		local x_start = math.random(3) + current_config.header_length
		local y_start = math.random(3, 15)
		vim.api.nvim_win_set_cursor(0, { x_start, y_start })
		self.line_length = vim.api.nvim_buf_line_count(0)
	end
	vim.schedule_wrap(_inner_update)()
end
function DeleteLineTask:teardown(autocmd_callback_data)
	local new_line_length = vim.api.nvim_buf_line_count(0)
	return new_line_length == self.line_length - 1
end
function DeleteLineTask:description()
	return "Delete the current line"
end

return DeleteLineTask
