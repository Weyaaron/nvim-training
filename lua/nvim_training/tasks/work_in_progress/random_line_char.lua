-- luacheck: globals vim

local BaseMovementTask = require("lua.nvim_training.tasks.base_movement")

local MoveRandomXYTask = BaseMovementTask:new()
local utility = require("nvim_training.utility")

MoveRandomXYTask.base_args = { tags = { "movement", "line_based" }, autocmds = { "CursorMoved" } }

local TestMovement = require("lua.nvim_training.movements.test_movement")
function MoveRandomXYTask:prepare()
	--This one is currently broken
	self:load_from_json("lorem_ipsum.buffer")
	utility.replace_main_buffer_with_str(self.initial_buffer)

	self.movement = TestMovement:new()

	self.new_buffer_coordinates = self.movement:calculate_cursor_x_y()

	self.desc = "Move to line " .. self.new_buffer_coordinates[1] .. "and " .. self.new_buffer_coordinates[2]

	local first_highlight =
		utility.create_highlight(self.new_buffer_coordinates[1] - 1, self.new_buffer_coordinates[2], 1)
	local second_highlight =
		utility.create_highlight(self.new_buffer_coordinates[1] - 1, 0, self.new_buffer_coordinates[2] - 1)

	local new_buffer_lines =
		vim.api.nvim_buf_get_lines(0, self.new_buffer_coordinates[1], self.new_buffer_coordinates[1] + 1, false)
	local line_length = #new_buffer_lines[1]
	local third_highlight = utility.create_highlight(
		self.new_buffer_coordinates[1] - 1,
		self.new_buffer_coordinates[2] + 2,
		line_length + 1
	)
	self.highlights = { first_highlight, second_highlight, third_highlight }
end

return MoveRandomXYTask
