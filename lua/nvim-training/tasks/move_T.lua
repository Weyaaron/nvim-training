local utility = require("nvim-training.utility")
local Move = require("nvim-training.tasks.move")
local movements = require("nvim-training.movements")
local tag_index = require("nvim-training.tag_index")

local MoveT = {}
MoveT.metadata = {
	autocmd = "CursorMoved",
	desc = "Go back next to the last ocurrence of a char.",
	instructions = "",
	tags = utility.flatten({ Move.metadata.tags, tag_index.T }),
}
setmetatable(MoveT, { __index = Move })
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
