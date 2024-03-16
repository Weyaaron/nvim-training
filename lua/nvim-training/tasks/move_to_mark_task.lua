local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local current_config = require("nvim-training.current_config")

local possible_marks = { "a", "b", "c", "r", "s", "t", "d", "n", "e" }
local MoveToMark = Task:new({
	target_line = 0,
	autocmd = "CursorMoved",
	mark_names = possible_marks,
	target_mark_index = 1,
})

MoveToMark.__index = MoveToMark

function MoveToMark:setup()
	self.target_mark_index = math.random(#possible_marks)
	self.target_line = math.random(current_config.header_length, current_config.header_length + 5)
	local function _inner_update()
		local lorem_ipsum = utility.lorem_ipsum_lines()
		utility.update_buffer_respecting_header(lorem_ipsum)

		utility.move_cursor_to_random_point()
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
