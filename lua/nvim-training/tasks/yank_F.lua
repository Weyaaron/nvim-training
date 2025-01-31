local utility = require("nvim-training.utility")
local movements = require("nvim-training.movements")
local Yank = require("nvim-training.tasks.yank")
local tag_index = require("nvim-training.tag_index")

local YankF = {}

YankF.__index = YankF
setmetatable(YankF, { __index = Yank })
YankF.__metadata = {
	autocmd = "TextYankPost",
	desc = "Yank back to the previous char.",
	instructions = "",
	tags = utility.flatten({ tag_index.yank, tag_index.F }),
}

function YankF:new()
	local base = Yank:new()
	setmetatable(base, { __index = YankF })
	return base
end

function YankF:activate()
	local line = utility.construct_char_line(self.target_char, self.cursor_center_pos - 10)
	self:yank_with_left_f_movement(line, movements.F)
end

function YankF:instructions()
	return "Yank to the target char '" .. self.target_char .. "'."
end

return YankF
