local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local user_config = require("nvim-training.user_config")

local MoveToMark = Task:new()

MoveToMark.__index = MoveToMark

function MoveToMark:new()
	local base = Task:new()
	setmetatable(base, { __index = MoveToMark })

	base.target_line = 0
	base.autocmd = "CursorMoved"
	base.target_mark_name = user_config.possible_marks_list[math.random(#user_config.possible_marks_list)]
	local function _inner_update()
		utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		if cursor_pos[1] == base.target_line then
			vim.api.nvim_win_set_cursor(0, { cursor_pos[1] + 1, cursor_pos[2] })
		end

		cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_buf_set_mark(0, base.target_mark_name, base.target_line, 0, {})

		local lines = vim.api.nvim_buf_get_lines(0, cursor_pos[1] - 1, cursor_pos[1], false)
		local line_length = #lines[1]
		utility.create_highlight(base.target_line - 1, 0, line_length)
	end
	vim.schedule_wrap(_inner_update)()
	return base
end

function MoveToMark:teardown(autocmd_callback_data)
	vim.api.nvim_buf_set_mark(0, self.target_mark_name, 0, 0, {})

	utility.clear_all_our_highlights()
	return self.target_line == vim.api.nvim_win_get_cursor(0)[1]
end

function MoveToMark:description()
	return "Move to mark " .. self.target_mark_name
end

return MoveToMark
