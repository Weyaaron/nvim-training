local utility = require("nvim-training.utility")
local movements = require("nvim-training.movements")
local Yank = require("nvim-training.tasks.yank")
local tag_index = require("nvim-training.tag_index")

local Yankt = {}
Yankt.__index = Yankt
setmetatable(Yankt, { __index = Yank })
Yankt.metadata = {
	autocmd = "TextYankPost",
	desc = "Yank next to the next char.",
	instructions = "",
	tags = utility.flatten({ Yank.metadata.tags, tag_index.t }),
}

function Yankt:new()
	local base = Yank:new()
	setmetatable(base, { __index = Yankt })
	return base
end

function Yankt:activate()
	local line = utility.construct_char_line(self.target_char, self.cursor_center_pos + 10)
	self:yank_with_right_f_movement(line, movements.t)
end

function Yankt:instructions()
	return "Yank to before the target char '" .. self.target_char .. "'."
end

return Yankt
