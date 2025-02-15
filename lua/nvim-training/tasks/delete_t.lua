local utility = require("nvim-training.utility")
local Delete = require("nvim-training.tasks.delete")
local movements = require("nvim-training.movements")
local tag_index = require("nvim-training.tag_index")

local Deletet = {}
Deletet.__index = Deletet
setmetatable(Deletet, { __index = Delete })
Deletet.metadata = {
	autocmd = "CursorMoved",
	desc = "Delete to the next char.",
	instructions = ".",
	tags = utility.flatten({ tag_index.deletion, tag_index.t }),
}

function Deletet:new()
	local base = Delete:new()
	setmetatable(base, { __index = Deletet })
	return base
end

function Deletet:activate()
	local line = utility.construct_char_line(self.target_char, self.cursor_center_pos + 10)
	self:delete_f(line, movements.t)
end

function Deletet:instructions()
	return "Delete next to the char '"
		.. self.target_char
		.. "'"
		.. utility.construct_register_description(self.target_register)
		.. "."
end

return Deletet
