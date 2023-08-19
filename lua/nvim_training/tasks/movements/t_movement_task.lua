-- luacheck: globals vim

local Task = require("nvim_training.task")
local tMovement = require("lua.nvim_training.movements.t_movement")

local tMovementTask = Task:new()
tMovementTask.base_args = { autocmds = { "CursorMoved" }, tags = { "buffer" } }
local utility = require("nvim_training.utility")

function tMovementTask:prepare()
	--Replace this with a list of chars actually contained in the
	--string

	self:load_from_json("permutation.buffer")
	utility.replace_main_buffer_with_str(self.initial_buffer)

	local current_cursor = vim.api.nvim_win_get_cursor(0)
	local current_buffer_lines = vim.api.nvim_buf_get_lines(0, current_cursor[1], current_cursor[1] + 1, false)
	local current_cursor_line = current_buffer_lines[1]
	local left_sub_str = string.sub(current_cursor_line, current_cursor[2], #current_cursor_line)
	local possible_chars = utility.generate_char_set(left_sub_str)

	local target_char = possible_chars[math.random(#possible_chars)]

	self.movement = tMovement:new()
	self.movement.target_char = target_char

	self.new_buffer_coordinates = self.movement:calculate_cursor_x_y()

	self.desc = "Jump before the next instance of " .. target_char .. "."

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
	if self.highlight_namespace then
		vim.api.nvim_buf_clear_namespace(0, self.highlight_namespace, 0, -1)
	end
end

return tMovementTask
