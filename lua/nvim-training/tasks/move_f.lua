local utility = require("nvim-training.utility")
local Move = require("nvim-training.tasks.move")
local movements = require("nvim-training.movements")
local Move_f = {}

Move_f.__index = Move_f
setmetatable(Move_f, { __index = Move })
Move_f.__metadata = {
	autocmd = "CursorMoved",
	desc = "Move using f.",
	instructions = "Move using f.",
	tags = "movement, f, horizontal",
}

function Move_f:new()
	local base = Move:new()
	setmetatable(base, { __index = Move_f })
	base.target_char = utility.calculate_target_char()
	return base
end

function Move_f:activate()
	local line = utility.construct_char_line(self.target_char, self.cursor_center_pos - 10)
	self:f_movement(line, movements.F)
end

function Move_f:instructions()
	return "Move to the char '" .. self.target_char .. "'"
end

return Move_f
