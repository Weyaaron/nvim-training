local utility = require("nvim-training.utility")
local Move = require("nvim-training.tasks.move")
local movements = require("nvim-training.movements")
local tag_index = require("nvim-training.tag_index")

local Move_f = {}
Move_f.__index = Move_f
Move_f.metadata = {
	autocmd = "CursorMoved",
	desc = "Find the next char.",
	instructions = "",
	tags = utility.flatten({ tag_index.movement, tag_index.f }),
	input_template = "<target_register>f<target_char>",
}
setmetatable(Move_f, { __index = Move })

function Move_f:new()
	local base = Move:new()

	setmetatable(base, { __index = Move_f })
	return base
end

function Move_f:activate()
	local line = utility.construct_char_line(self.target_char, self.cursor_center_pos + 10)
	self:f_movement(line, movements.f)
end

function Move_f:instructions()
	return "Move to the char '" .. self.target_char .. "'"
end

return Move_f
