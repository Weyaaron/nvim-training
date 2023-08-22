-- luacheck: globals vim

local Task = require("nvim_training.task")
local eMovementTask = Task:new()
eMovementTask.base_args = { autocmds = { "CursorMoved" }, tags = { "buffer" } }
local utility = require("nvim_training.utility")

function eMovementTask:prepare()
	self:load_from_json("permutation.buffer")
	utility.replace_main_buffer_with_str(self.initial_buffer)
	local offset = math.random(3, 7)

	local cursor_position = vim.api.nvim_win_get_cursor(0)
	local cursor_node = self.buffer_as_list:traverse_to_line_char(cursor_position[1], cursor_position[2])

	local e_movement_result = cursor_node:e(cursor_position[1], cursor_position[2], offset)
	local target_note = e_movement_result[1]
	offset = e_movement_result[2]
	self.desc = "Jump  to the end of the " .. offset .. "th word: " .. target_note.content
	self.new_buffer_coordinates = { target_note.line_index, target_note.end_index - 2 }

	self.highlight = utility.create_highlights(self.new_buffer_coordinates[1] - 1, self.new_buffer_coordinates[2], 1)
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
	utility.clear_highlight(self.highlight)
end
return eMovementTask
