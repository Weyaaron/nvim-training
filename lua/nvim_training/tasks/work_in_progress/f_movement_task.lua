-- luacheck: globals vim
local utility = require("lua.nvim_training.utility")

local FMovementTask = require("lua.nvim_training.tasks.base_movement"):new()
FMovementTask.base_args = { autocmds = { "CursorMoved" }, tags = { "buffer" } }

function FMovementTask:setup()
	--This task is currently not implemented properly!
	self:load_from_json("permutation.buffer")
	utility.replace_main_buffer_with_str(self.initial_buffer)
	self.buffer_as_list = utility.construct_linked_list()

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
	local current_char = string.sub(current_cursor_line, current_cursor[2] + 1, current_cursor[2] + 1)
	while target_char == current_char do
		target_char = possible_chars[math.random(#possible_chars)]
	end

	--This task has an open issue where sometimes the char is found in before the cursor.
	--At the moment, the solution is that the user using F.
	local cursor_node = self.buffer_as_list:traverse_to_line_char(current_cursor[1], current_cursor[2])
	local movement_result = cursor_node:f(target_char)
	self.target_node = movement_result.node
	self.new_buffer_coordinates = { self.target_node.line_index, movement_result.offset }
	self.instruction = "Move to the instance of " .. target_char .. "."

	self.highlight = utility.create_highlight(self.new_buffer_coordinates[1] - 1, self.new_buffer_coordinates[2], 1)
end

return FMovementTask
