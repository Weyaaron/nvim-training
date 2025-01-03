local Task = require("nvim-training.task")
local logging = require("nvim-training.logging")
local Move = {}
local utility = require("nvim-training.utility")
Move.__index = Move
setmetatable(Move, { __index = Task })
Move.__metadata = { autocmd = "", desc = "", instructions = "", tags = "movement" }

function Move:new()
	local base = Task:new()
	setmetatable(base, Move)

	self.cursor_target = { 0, 0 }
	return base
end
function Move:deactivate()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	if not type(self.cursor_target) == "table" then
		print("Target has to be type table, current value is " .. tostring(self.cursor_target))
	end
	logging.log(
		"The cursor positions have been compared",
		{ cursor_pos = cursor_pos, cursor_target = self.cursor_target }
	)
	return cursor_pos[1] == self.cursor_target[1] and cursor_pos[2] == self.cursor_target[2]
end

function Move:f_movement(line, f_movement)
	local function _inner_update()
		utility.set_buffer_to_rectangle_with_line(line)

		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { cursor_pos[1], self.cursor_center_pos })

		cursor_pos = vim.api.nvim_win_get_cursor(0)
		local new_x_pos = f_movement(line, cursor_pos[2], self.target_char)
		self.cursor_target = { cursor_pos[1], new_x_pos }

		utility.construct_highlight(self.cursor_target[1], self.cursor_target[2], 1)
	end
	vim.schedule_wrap(_inner_update)()
end
return Move
