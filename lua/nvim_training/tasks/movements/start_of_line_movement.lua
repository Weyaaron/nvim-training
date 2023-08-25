-- luacheck: globals vim

local utility = require("lua.nvim_training.utility")
local StartOfLineMovementTask = require("lua.nvim_training.tasks.base_movement"):new()

StartOfLineMovementTask.base_args = { tags = { "movement" }, autocmds = { "CursorMoved" }, help = " (Tip: Use 0)" }

function StartOfLineMovementTask:setup()
	self:load_from_json("lorem_ipsum.buffer")

	utility.replace_main_buffer_with_str(self.initial_buffer)

	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	if cursor_pos == 0 then
		local new_pos = math.random(5, 10)
		vim.api.nvim_win_set_cursor(0, { cursor_pos[1], new_pos })
	end

	self.desc = "Move to the start of the line."
	self.new_buffer_coordinates = { cursor_pos[1], 0 }

	self.highlight = utility.create_highlight(self.new_buffer_coordinates[1] - 1, self.new_buffer_coordinates[2], 1)
end
return StartOfLineMovementTask
