-- luacheck: globals vim

local utility = require("lua.nvim_training.utility")
local MoveWordForwardTask = require("lua.nvim_training.tasks.base_movement"):new()

MoveWordForwardTask.base_args =
	{ cursor_target = 0, tags = { "movement" }, autocmds = { "CursorMoved" }, help = " (Tip: Use w)" }

function MoveWordForwardTask:setup()
	self:load_from_json("lorem_ipsum.buffer")

	utility.replace_main_buffer_with_str(self.initial_buffer)

	local offset = math.random(2, 10)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local move_to_cursor = self.buffer_as_list:traverse_to_line_char(cursor_pos[1], cursor_pos[2])
	local movement_result = move_to_cursor:w(offset)
	self.desc = "Move " .. tostring(offset) .. " words."
	self.new_buffer_coordinates = { movement_result.line_index, movement_result.end_index }

	self.highlight = utility.create_highlight(self.new_buffer_coordinates[1] - 1, self.new_buffer_coordinates[2], 1)
end

return MoveWordForwardTask
