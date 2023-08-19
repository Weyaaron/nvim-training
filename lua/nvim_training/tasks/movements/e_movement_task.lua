-- luacheck: globals vim

local Task = require("nvim_training.task")
local eMovement = require("lua.nvim_training.movements.e_movement")

local eMovementTask = Task:new()
eMovementTask.base_args = { autocmds = { "CursorMoved" }, tags = { "buffer" } }
local utility = require("nvim_training.utility")

function eMovementTask:prepare()
	self:load_from_json("permutation.buffer")
	utility.replace_main_buffer_with_str(self.initial_buffer)
	local jump_distance = math.random(10)

	self.movement = eMovement:new()
	local cursor_position = vim.api.nvim_win_get_cursor(0)
	local cursor_node = self.movement.buffer_as_list:traverse_to_line_char(cursor_position[1], cursor_position[2])
	local end_diff = cursor_node.end_index - cursor_position[2] - 2
	print("end diff with node " .. cursor_node.content .. " " .. end_diff)
	if not (end_diff == 0) then
		jump_distance = jump_distance - 1
	end
	self.movement.offset = jump_distance
	self.new_buffer_coordinates = self.movement:calculate_cursor_x_y()

	local content_word = cursor_node:traverse_n(jump_distance).content

	self.desc = "Jump  to the end of the " .. jump_distance .. "th word: " .. content_word

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

function eMovementTask:completed()
	local current_cursor = vim.api.nvim_win_get_cursor(0)
	local x_diff = current_cursor[1] - self.new_buffer_coordinates[1]
	local y_diff = current_cursor[2] - self.new_buffer_coordinates[2]
	return x_diff == 0 and y_diff == 0
end

function eMovementTask:failed()
	return not self:completed()
end

function eMovementTask:teardown()
	if self.highlight_namespace then
		vim.api.nvim_buf_clear_namespace(0, self.highlight_namespace, 0, -1)
	end
end
return eMovementTask
