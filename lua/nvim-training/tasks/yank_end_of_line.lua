local utility = require("nvim-training.utility")
local current_config = require("nvim-training.current_config")
local YankTask = require("nvim-training.tasks.yank_task")

local YankEndOfLine = YankTask:new()
YankEndOfLine.__index = YankEndOfLine

function YankEndOfLine:new()
	local base = YankTask:new()

	setmetatable(base, { __index = YankEndOfLine })

	self.autocmd = "TextYankPost"
	local function _inner_update()
		utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()
		local x_start = math.random(3) + current_config.header_length
		local y_start = math.random(3, 15)
		local lines = vim.api.nvim_buf_get_lines(0, x_start - 1, vim.api.nvim_buf_line_count(0), false)
		self.target_text = string.sub(lines[1], y_start + 1, #lines[1])
		vim.api.nvim_win_set_cursor(0, { x_start, y_start })
	end
	vim.schedule_wrap(_inner_update)()
	return base
end

function YankEndOfLine:description()
	return "Yank the text from the cursor to the end of the line"
end

return YankEndOfLine
