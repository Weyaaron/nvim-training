local utility = require("nvim-training.utility")
local Move = require("nvim-training.tasks.move")
local movements = require("nvim-training.movements")

local MoveT = {}
MoveT.__index = MoveT
setmetatable(MoveT, { __index = Move })
MoveT.__metadata = {
	autocmd = "CursorMoved",
	desc = "Move using T.",
	instructions = "",
	tags = "movement, T, horizontal",
}

function MoveT:new()
	local base = Move:new()
	setmetatable(base, { __index = MoveT })
	base.target_char = utility.calculate_target_char()
	return base
end

function MoveT:activate()
	local line = utility.construct_char_line(self.target_char, self.cursor_center_pos - 10)
	self:f_movement(line, movements.T)
end

function MoveT:instructions()
	return "Move next to the char '" .. self.target_char .. "'"
end

return MoveT
