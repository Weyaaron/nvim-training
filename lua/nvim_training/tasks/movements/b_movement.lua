-- luacheck: globals vim

local utility = require("lua.nvim_training.utility")
local bMovementTask = require("lua.nvim_training.tasks.base_movement"):new()

bMovementTask.base_args = { tags = { "movement" }, autocmds = { "CursorMoved" }, help = " (Tip: Use b)" }

function bMovementTask:setup()
	self:load_from_json("lorem_ipsum.buffer")

	utility.replace_main_buffer_with_str(self.initial_buffer)

	local offset = math.random(3, 6)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local move_to_cursor = self.buffer_as_list:traverse_to_line_char(cursor_pos[1], cursor_pos[2])
	local movement_result = move_to_cursor:b(offset, cursor_pos[2])

	offset = movement_result.offset
	movement_result = movement_result.node
	self.desc = "Move " .. tostring(offset) .. " words back."
	self.new_buffer_coordinates = { movement_result.line_index, movement_result.start_index - 1 }

	self.highlight = utility.create_highlight(self.new_buffer_coordinates[1] - 1, self.new_buffer_coordinates[2], 1)
end

return bMovementTask
