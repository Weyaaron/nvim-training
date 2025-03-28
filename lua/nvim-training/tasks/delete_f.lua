local Delete = require("nvim-training.tasks.delete")
local utility = require("nvim-training.utility")
local movements = require("nvim-training.movements")
local tag_index = require("nvim-training.tag_index")

local Deletef = {}
Deletef.__index = Deletef
setmetatable(Deletef, { __index = Delete })
Deletef.metadata = {
	autocmd = "CursorMoved",
	desc = "Delete forward to the next char.",
	instructions = ".",
	tags = utility.flatten({ tag_index.deletion, tag_index.f }),
	input_template = "<target_register>df<target_char>",
}

function Deletef:new()
	local base = Delete:new()
	setmetatable(base, { __index = Deletef })
	self.target_char = utility.calculate_target_char()
	return base
end

function Deletef:activate()
	local line = utility.construct_char_line(self.target_char, self.cursor_center_pos + 10)
	self:delete_f(line, movements.f)
end

function Deletef:instructions()
	return "Delete to the char '"
		.. self.target_char
		.. "'"
		.. utility.construct_register_description(self.target_register)
		.. "."
end

return Deletef
