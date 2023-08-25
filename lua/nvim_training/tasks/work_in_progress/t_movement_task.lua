-- luacheck: globals vim

local tMovementTask = require("lua.nvim_training.tasks.base_movement"):new()
tMovementTask.base_args = { autocmds = { "CursorMoved" }, tags = { "buffer" } }
local utility = require("nvim_training.utility")

function tMovementTask:setup()
	--This is currently not properly implemented
	self:load_from_json("permutation.buffer")
	utility.replace_main_buffer_with_str(self.initial_buffer)

	local current_cursor = vim.api.nvim_win_get_cursor(0)
	local right_cursor_bound = 15
	if current_cursor[2] > right_cursor_bound then
		local new_cursor_pos = math.random(right_cursor_bound)
		vim.api.nvim_win_set_cursor(0, { current_cursor[1], new_cursor_pos })
	end
	current_cursor = vim.api.nvim_win_get_cursor(0)

	local current_buffer_lines = vim.api.nvim_buf_get_lines(0, current_cursor[1] - 1, current_cursor[1], false)
	local current_cursor_line = current_buffer_lines[1]
	local left_sub_str = string.sub(current_cursor_line, current_cursor[2], #current_cursor_line)
	local possible_chars = utility.generate_char_set(left_sub_str)

	local target_char = possible_chars[math.random(#possible_chars)]
	--This ensures that we are not stuck searching for the char next to us
	local current_char = string.sub(current_cursor_line, current_cursor[2] + 2, current_cursor[2] + 2)
	while target_char == current_char do
		target_char = possible_chars[math.random(#possible_chars)]
	end

	local cursor_node = self.buffer_as_list:traverse_to_line_char(current_cursor[1], current_cursor[2])
	local movement_result = cursor_node:t(target_char)
	local target_node = movement_result.node
	local offset = movement_result.offset
	self.desc = "Move before the next instance of " .. target_char .. "."

	self.new_buffer_coordinates = {
		target_node.line_index,
		offset,
	}

	self.highlight = utility.create_highlight(self.new_buffer_coordinates[1] - 1, self.new_buffer_coordinates[2], 2)
end

return tMovementTask
