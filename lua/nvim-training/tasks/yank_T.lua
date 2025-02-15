local utility = require("nvim-training.utility")
local movements = require("nvim-training.movements")
local Yank = require("nvim-training.tasks.yank")
local tag_index = require("nvim-training.tag_index")

local YankT = {}
YankT.__index = YankT
setmetatable(YankT, { __index = Yank })
YankT.metadata = {
	autocmd = "TextYankPost",
	desc = "Yank back next to the previous char.",
	instructions = "",
	tags = utility.flatten({ tag_index.yank, tag_index.T }),
}

function YankT:new()
	local base = Yank:new()
	setmetatable(base, { __index = YankT })
	return base
end

function YankT:activate()
	local line = utility.construct_char_line(self.target_char, self.cursor_center_pos - 10)
	self:yank_f(line, movements.T)
end

function YankT:instructions()
	return "Yank to the target char '"
		.. self.target_char
		.. "'"
		.. utility.construct_register_description(self.target_register)
		.. "."
end

return YankT
