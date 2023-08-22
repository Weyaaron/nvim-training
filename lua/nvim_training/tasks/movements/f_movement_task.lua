-- luacheck: globals vim
local utility = require("lua.nvim_training.utility")

local Task = require("nvim_training.task")
local FMovementTask = Task:new()
FMovementTask.base_args = { autocmds = { "CursorMoved" }, tags = { "buffer" } }

function FMovementTask:prepare()
	self:load_from_json("permutation.buffer")
	utility.replace_main_buffer_with_str(self.initial_buffer)
	self.buffer_as_list = utility.construct_linked_list()

	local current_cursor = vim.api.nvim_win_get_cursor(0)
	local current_buffer_lines = vim.api.nvim_buf_get_lines(0, current_cursor[1] - 1, current_cursor[1], false)
	local current_cursor_line = current_buffer_lines[1]
	local left_sub_str = string.sub(current_cursor_line, current_cursor[2], #current_cursor_line)
	local possible_chars = utility.generate_char_set(left_sub_str)

	--One recurring issue is that the movement may be stuck if you start at the char you
	--are searching for. This has to be fixed, but I have no clue how.

	local target_char = possible_chars[math.random(#possible_chars)]
	local cursor_node = self.buffer_as_list:traverse_to_line_char(current_cursor[1], current_cursor[2])
	self.target_node = cursor_node:f(target_char)
	print("target_node = " .. self.target_node.content)

	local char_index = utility.search_for_char_in_word(self.target_node.content, target_char)
	self.new_buffer_coordinates = { self.target_node.line_index, self.target_node.start_index + char_index - 2 }
	print("Coordinates" .. self.new_buffer_coordinates[1] .. " " .. self.new_buffer_coordinates[2])
	self.desc = "Jump to the next instance of " .. target_char .. "."

	self.highlight = utility.create_highlights(self.new_buffer_coordinates[1] - 1, self.new_buffer_coordinates[2], 1)
end

function FMovementTask:completed()
	local current_cursor = vim.api.nvim_win_get_cursor(0)
	local x_diff = current_cursor[1] - self.new_buffer_coordinates[1]
	local y_diff = current_cursor[2] - self.new_buffer_coordinates[2]
	--print(x_diff .. " - " .. y_diff)
	return x_diff == 0 and y_diff == 0
end

function FMovementTask:failed()
	return not self:completed()
end

function FMovementTask:teardown()
	utility.clear_highlight(self.highlight)
end

return FMovementTask
