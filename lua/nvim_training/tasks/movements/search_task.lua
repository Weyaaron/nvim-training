local Task = require("nvim_training.task")
local SearchMovement = require("lua.nvim_training.movements.search_movement")
local SearchTask = Task:new()
SearchTask.base_args = { autocmds = { "CursorMoved" }, tags = { "buffer" } }

local linked_list = require("nvim_training.linked_list")
local utility = require("nvim_training.utility")

function SearchTask:prepare()
	local offset = math.random(10)
	local offset = 12

	self:load_from_json("permutation.buffer")
	utility.replace_main_buffer_with_str(self.initial_buffer)

	self.movement = SearchMovement:new()
	self.movement.offset = offset

	self.new_buffer_coordinates = self.movement:calculate_cursor_x_y()
	local cursor_position = vim.api.nvim_win_get_cursor(0)
	local cursor_node = self.movement.buffer_as_list:traverse_to_line_char(cursor_position[1], cursor_position[2])
	local content_word = cursor_node:traverse_n(offset).content
	self.desc = "Jump to the next instance of " .. content_word .. " using search."

	self.highlight_namespace = vim.api.nvim_create_namespace("TestTaskNameSpace")

	vim.api.nvim_set_hl(0, "UnderScore", { underline = true })

	vim.api.nvim_buf_add_highlight(
		0,
		self.highlight_namespace,
		"UnderScore",
		self.new_buffer_coordinates[1] - 1,
		self.new_buffer_coordinates[2],
		self.new_buffer_coordinates[2] + 1
	)
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
	if self.highlight_namespace then
		vim.api.nvim_buf_clear_namespace(0, self.highlight_namespace, 0, -1)
	end
end

return SearchTask
