-- luacheck: globals vim

local Task = require("nvim_training.task")

local tMovementTask = Task:new()
tMovementTask.base_args = { autocmds = { "CursorMoved" }, tags = { "buffer" } }
local utility = require("nvim_training.utility")

function tMovementTask:prepare()
	self:load_from_json("permutation.buffer")
	utility.replace_main_buffer_with_str(self.initial_buffer)


	local current_cursor = vim.api.nvim_win_get_cursor(0)
	local current_line = vim.api.nvim_buf_get_lines(0, current_cursor[1], current_cursor[1] + 1, false)[1]
	local current_line_as_list = utility.construct_linked_list(current_line)
	--Doing this no sucks  matter which way ...

	local left_sub_str = string.sub(current_cursor_line, current_cursor[2], #current_cursor_line)
	local possible_chars = utility.generate_char_set(left_sub_str)
	local target_char = possible_chars[math.random(#possible_chars)]




	local cursor_node = self.buffer_as_list:traverse_to_line_char(current_cursor[1], current_cursor[2])
	local target_node = cursor_node:t(target_char)

	self.desc = "Jump before the next instance of " .. target_char .. "."

	self.new_buffer_coordinates = {
		target_node.line_index,
		target_node.start_index + utility.search_for_char_in_word(target_node.content, target_char) - 1,
	}

	self.highlight = utility.create_highlight(self.new_buffer_coordinates[1] - 1, self.new_buffer_coordinates[2], 2)
end

function tMovementTask:completed()
	local current_cursor = vim.api.nvim_win_get_cursor(0)
	local x_diff = current_cursor[1] - self.new_buffer_coordinates[1]
	local y_diff = current_cursor[2] - self.new_buffer_coordinates[2]
	return x_diff == 0 and y_diff == 0
end

function tMovementTask:failed()
	return not self:completed()
end

function tMovementTask:teardown()
	utility.clear_highlight(self.highlight)
end

return tMovementTask
--[[


	local current_cursor = vim.api.nvim_win_get_cursor(0)

	local cursor_node = self.buffer_as_list:traverse_to_line_char(current_cursor[1], current_cursor[2])
	local offset = math.random(3,12)

	local word_source_node = cursor_node:traverse_n(offset)
	local word_offset = math.random(1, #word_source_node.content)
	local target_char = string.sub(word_source_node.content, word_offset, word_offset)
	print("target_char is:" .. target_char)
--]]
