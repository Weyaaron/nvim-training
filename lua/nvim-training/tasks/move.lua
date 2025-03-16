local Task = require("nvim-training.task")
local logging = require("nvim-training.logging")
local utility = require("nvim-training.utility")

local Move = {}
Move.__index = Move
setmetatable(Move, { __index = Task })
Move.metadata = { autocmd = "", desc = "", instructions = "", tags = { "movement" } }

function Move:new()
	local base = Task:new()
	setmetatable(base, Move)

	base.cursor_target = { 0, 0 }
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
	utility.update_debug_state({ cp = cursor_pos, tcp = self.cursor_target })
	return cursor_pos[1] == self.cursor_target[1] and cursor_pos[2] == self.cursor_target[2]
end

function Move:f_movement(line, f_movement)
	local function _inner_update()
		self.cursor_target = utility.do_f_preparation(line, f_movement, self.target_char)
	end
	vim.schedule_wrap(_inner_update)()
end
return Move
