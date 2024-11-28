local utility = require("nvim-training.utility")
local movements = require("nvim-training.movements")
local Yank = require("nvim-training.tasks.yank")

local Yankf = {}

Yankf.__index = Yankf
setmetatable(Yankf, { __index = Yank })
Yankf.__metadata = {
	autocmd = "TextYankPost",
	desc = "Yank to the next char.",
	instructions = "",
	tags = "yank, f, horizontal,",
}

function Yankf:new()
	local base = Yank:new()
	setmetatable(base, { __index = Yankf })
	return base
end

function Yankf:activate()
	local line = utility.construct_char_line(self.target_char, self.cursor_center_pos + 10)
	self:yank_with_right_f_movement(line, movements.f)
end

function Yankf:instructions()
	return "Yank to the target char '" .. self.target_char .. "'."
end

return Yankf
