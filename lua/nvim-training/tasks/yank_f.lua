local utility = require("nvim-training.utility")
local movements = require("nvim-training.movements")
local Yank = require("nvim-training.tasks.yank")
local tag_index = require("nvim-training.tag_index")

local Yankf = {}
Yankf.__index = Yankf
setmetatable(Yankf, { __index = Yank })
Yankf.metadata = {
	autocmd = "TextYankPost",
	desc = "Yank to the next char.",
	instructions = "",
	tags = utility.flatten({ tag_index.yank, tag_index.f }),
	input_template = "<target_register>yf<target_char>",
}

function Yankf:new()
	local base = Yank:new()
	setmetatable(base, { __index = Yankf })
	return base
end

function Yankf:activate()
	local line = utility.construct_char_line(self.target_char, self.cursor_center_pos + 10)
	self:yank_f(line, movements.f)
end

function Yankf:instructions()
	return "Yank to the target char '"
		.. self.target_char
		.. "'"
		.. utility.construct_register_description(self.target_register)
		.. "."
end

return Yankf
