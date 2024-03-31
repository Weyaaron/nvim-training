local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local current_config = require("nvim-training.current_config")

local MoveToMark = {}

MoveToMark.__index = MoveToMark

function MoveToMark:new()
	local base = Task:new()
	setmetatable(base, { __index = MoveToMark })

	self.target_line = 0
	self.autocmd = "CursorMoved"
	self.mark_names = current_config.possible_marks_list
	self.target_mark_index = math.random(#self.mark_names)
	local function _inner_update()
		utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		if cursor_pos[1] == self.target_line then
			vim.api.nvim_win_set_cursor(0, { cursor_pos[1] + 1, cursor_pos[2] })
		end

		cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_buf_set_mark(0, self.mark_names[self.target_mark_index], self.target_line, 0, {})

		local lines = vim.api.nvim_buf_get_lines(0, cursor_pos[1] - 1, cursor_pos[1], false)
		local line_length = #lines[1]
		self.highlight = utility.create_highlight(self.target_line - 1, 0, line_length)
	end
	vim.schedule_wrap(_inner_update)()
	return base
end

function MoveToMark:teardown(autocmd_callback_data)
	self:teardown_all_marks()
	utility.clear_highlight(self.highlight)
	return self.target_line == vim.api.nvim_win_get_cursor(0)[1]
end

function MoveToMark:teardown_all_marks()
	vim.api.nvim_buf_set_mark(0, self.mark_names[self.target_mark_index], 0, 0, {})
end
function MoveToMark:description()
	return "Move to mark " .. self.mark_names[self.target_mark_index]
end

return MoveToMark
