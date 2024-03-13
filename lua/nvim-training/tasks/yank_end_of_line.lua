local utility = require("nvim-training.utility")
local current_config = require("nvim-training.current_config")
local YankTask = require("nvim-training.tasks.yank_task")

local YankEndOfLine = YankTask:new({ autocmd = "TextYankPost" })
YankEndOfLine.__index = YankEndOfLine

function YankEndOfLine:setup()
	local function _inner_update()
		local lorem_ipsum = utility.lorem_ipsum_lines(4)
		utility.update_buffer_respecting_header(lorem_ipsum)

		local x_start = math.random(3) + current_config.header_length
		local y_start = math.random(3, 15)
		local lines = vim.api.nvim_buf_get_lines(0, x_start - 1, vim.api.nvim_buf_line_count(0), false)
		self.target_text = string.sub(lines[1], y_start + 1, #lines[1])
		vim.api.nvim_win_set_cursor(0, { x_start, y_start })
	end
	vim.schedule_wrap(_inner_update)()
end

function YankEndOfLine:description()
	return "Yank the text from the cursor to the end of the line"
end

return YankEndOfLine
