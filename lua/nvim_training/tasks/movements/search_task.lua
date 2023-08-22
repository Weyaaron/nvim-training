-- luacheck: globals vim

local Task = require("nvim_training.task")
local SearchTask = Task:new()
SearchTask.base_args = { autocmds = { "CursorMoved" }, tags = { "buffer" } }

local utility = require("nvim_training.utility")

function SearchTask:prepare()
	self:load_from_json("permutation.buffer")
	utility.replace_main_buffer_with_str(self.initial_buffer)
	self.buffer_as_list = utility.construct_linked_list()

	local offset = math.random(2, 15)
	local cursor_position = vim.api.nvim_win_get_cursor(0)
	local cursor_node = self.buffer_as_list:traverse_to_line_char(cursor_position[1], cursor_position[2])

	local content_word = cursor_node:traverse_n(offset).content
	self.desc = "Jump to the next instance of '" .. content_word .. "' using search."

	local target_node = cursor_node:search(content_word)
	self.new_buffer_coordinates = { target_node.line_index, target_node.start_index - 1 }
	self.highlight =
		utility.create_highlight(target_node.line_index - 1, target_node.start_index - 1, #target_node.content)
end

function SearchTask:completed()
	local current_cursor = vim.api.nvim_win_get_cursor(0)
	local x_diff = current_cursor[1] - self.new_buffer_coordinates[1]
	local y_diff = current_cursor[2] - self.new_buffer_coordinates[2]
	return x_diff == 0 and y_diff == 0
end

function SearchTask:failed()
	return not self:completed()
end

function SearchTask:teardown()
	utility.clear_highlight(self.highlight)
end

return SearchTask
