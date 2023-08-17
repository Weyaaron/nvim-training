local Task = require("nvim_training.task")

local TestMovement = require("lua.nvim_training.movements.test_movement")
local fMovement = require("lua.nvim_training.movements.f_movement")

local TestTask = Task:new()
TestTask.base_args = { autocmds = { "CursorMoved" }, tags = { "buffer" } }
local utility = require("nvim_training.utility")

function TestTask:prepare()
	self:load_from_json("permutation.buffer")
	utility.replace_main_buffer_with_str(self.initial_buffer)

	self.movement = fMovement:new()

	self.new_buffer_coordinates = self.movement:calculate_cursor_x_y()

	self.desc = "Jump to " .. self.new_buffer_coordinates[1] .. "," .. self.new_buffer_coordinates[2]

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

function TestTask:completed()
	local current_cursor = vim.api.nvim_win_get_cursor(0)
	print("You jumped to " .. tostring(current_cursor[1]) .. ", " .. tostring(current_cursor[2]))
	local x_diff = current_cursor[1] - self.new_buffer_coordinates[1]
	local y_diff = current_cursor[2] - self.new_buffer_coordinates[2]
	print(x_diff .. ", " .. y_diff)
	return x_diff == 0 and y_diff == 0
end

function TestTask:failed()
	return not self:completed()
end

function TestTask:teardown()
	if self.highlight_namespace then
		vim.api.nvim_buf_clear_namespace(0, self.highlight_namespace, 0, -1)
	end
end

return TestTask
