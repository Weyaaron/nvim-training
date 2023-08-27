-- luacheck: globals vim

local utility = require("lua.nvim_training.utility")
local DollarTask = require("lua.nvim_training.tasks.base_movement"):new()

DollarTask.base_args = {
	tags = { "movement", "line_based", "absolute", "horizontal" },
	autocmds = { "CursorMoved" },
	help = " (Tip: Use $)",
	min_level = 4,
	description = "Move to the end of the line.",
}

function DollarTask:setup()
	self:load_from_json("lorem_ipsum.buffer")

	utility.replace_main_buffer_with_str(self.initial_buffer)

	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local current_buffer_lines = vim.api.nvim_buf_get_lines(0, cursor_pos[1] - 1, cursor_pos[1], false)
	local current_cursor_line_len = #current_buffer_lines[1]
	local diff = cursor_pos[2] - current_cursor_line_len
	--This accounts for a cursor that is at the end of a line.
	if diff == -1 then
		local new_pos = math.random(5, current_cursor_line_len - 5)
		vim.api.nvim_win_set_cursor(0, { cursor_pos[1], new_pos })
	end

	local move_to_cursor = self.buffer_as_list:traverse_to_line_char(cursor_pos[1], cursor_pos[2])
	local movement_result = move_to_cursor:dollar()
	self.instruction = "Move to the end of the line."
	self.new_buffer_coordinates = { movement_result.line_index, movement_result.end_index - 2 }

	self.highlight = utility.create_highlight(self.new_buffer_coordinates[1] - 1, self.new_buffer_coordinates[2], 1)
end
return DollarTask
