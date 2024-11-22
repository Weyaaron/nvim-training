local utility = require("nvim-training.utility")
local Move = require("nvim-training.tasks.move")
local movements = require("nvim-training.movements")
local Movet = {}

Movet.__index = Movet
setmetatable(Movet, { __index = Move })
Movet.__metadata = {
	autocmd = "CursorMoved",
	desc = "Move using t.",
	instructions = "",
	tags = "movement, t, horizontal",
}

function Movet:new()
	local base = Move:new()
	setmetatable(base, { __index = Movet })
	base.target_char = utility.calculate_target_char()
	return base
end

function Movet:activate()
	local line = utility.construct_char_line(self.target_char, self.cursor_center_pos + 10)
	self:f_movement(line, movements.t)
end

function Movet:instructions()
	return "Move next to the char '" .. self.target_char .. "'"
end

return Movet
