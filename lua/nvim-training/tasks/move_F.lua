local utility = require("nvim-training.utility")
local Move = require("nvim-training.tasks.move")
local movements = require("nvim-training.movements")
local tag_index = require("nvim-training.tag_index")

local MoveF = {}
MoveF.__index = MoveF
setmetatable(MoveF, { __index = Move })
MoveF.metadata = {
	autocmd = "CursorMoved",
	desc = "Go back to the last ocurrence of a char.",
	instructions = "",
	tags = utility.flatten({ Move.metadata.tags, tag_index.F }),
}

function MoveF:new()
	local base = Move:new()
	setmetatable(base, { __index = MoveF })
	return base
end

function MoveF:activate()
	local line = utility.construct_char_line(self.target_char, self.cursor_center_pos - 10)
	self:f_movement(line, movements.F)
end

function MoveF:instructions()
	return "Move to the char '" .. self.target_char .. "'"
end

return MoveF
