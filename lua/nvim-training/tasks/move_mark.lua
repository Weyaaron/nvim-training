local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local user_config = require("nvim-training.user_config")
local internal_config = require("nvim-training.internal_config")

local MoveMark = {}
MoveMark.__index = MoveMark
setmetatable(MoveMark, { __index = Task })
MoveMark.__metadata =
	{ autocmd = "CursorMoved", desc = "Move to a mark", instructions = "", tags = "mark, movement, vertical" }

function MoveMark:new()
	local base = Task:new()
	setmetatable(base, { __index = MoveMark })
	base.target_mark_name = user_config.possible_marks_list[math.random(#user_config.possible_marks_list)]
	base.target_line = math.random(internal_config.header_length, internal_config.header_length + 4)
	-- base.target_mark_name = "r"
	-- base.target_line = 11
	return base
end

function MoveMark:activate()
	local function _inner_update()
		utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		if cursor_pos[1] == self.target_line then
			vim.api.nvim_win_set_cursor(0, { cursor_pos[1] + 1, cursor_pos[2] })
		end

		cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_buf_set_mark(0, self.target_mark_name, self.target_line, 0, {})

		local line = utility.get_line(cursor_pos[1])
		local line_length = #line
		utility.create_highlight(self.target_line - 1, 0, line_length)
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveMark:deactivate(autocmd_callback_data)
	vim.api.nvim_buf_set_mark(0, self.target_mark_name, 0, 0, {})
	return self.target_line == vim.api.nvim_win_get_cursor(0)[1]
end

function MoveMark:instructions()
	return "Move to mark " .. self.target_mark_name
end

return MoveMark
