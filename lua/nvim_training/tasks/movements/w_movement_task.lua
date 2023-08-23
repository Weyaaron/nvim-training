-- luacheck: globals vim

local Task = require("lua.nvim_training.task")
local utility = require("lua.nvim_training.utility")
local MoveWordForwardTask = Task:new()

MoveWordForwardTask.base_args = { cursor_target = 0, tags = { "movement" }, autocmds = { "CursorMoved" } }

function MoveWordForwardTask:prepare()
	self:load_from_json("lorem_ipsum.buffer")

	utility.replace_main_buffer_with_str(self.initial_buffer)

	local offset = math.random(2, 10)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local move_to_cursor = self.buffer_as_list:traverse_to_line_char(cursor_pos[1], cursor_pos[2])
	local movement_result = move_to_cursor:w(offset)
	self.desc = "Move " .. tostring(offset) .. " words relative to your cursor using w."
	self.new_buffer_coordinates = { movement_result.line_index, movement_result.end_index }

	self.highlight = utility.create_highlight(self.new_buffer_coordinates[1] - 1, self.new_buffer_coordinates[2], 1)
end

function MoveWordForwardTask:completed()
	local current_cursor = vim.api.nvim_win_get_cursor(0)
	local x_diff = current_cursor[1] - self.new_buffer_coordinates[1]
	local y_diff = current_cursor[2] - self.new_buffer_coordinates[2]
	return x_diff == 0 and y_diff == 0
end

function MoveWordForwardTask:failed()
	return not self:completed()
end

function MoveWordForwardTask:teardown()
	utility.clear_highlight(self.highlight)
end

return MoveWordForwardTask
