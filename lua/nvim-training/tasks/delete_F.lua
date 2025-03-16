local Delete = require("nvim-training.tasks.delete")
local utility = require("nvim-training.utility")
local movements = require("nvim-training.movements")
local tag_index = require("nvim-training.tag_index")

local DeleteF = {}
DeleteF.__index = DeleteF
setmetatable(DeleteF, { __index = Delete })
DeleteF.metadata = {
	autocmd = "CursorMoved",
	desc = "Delete back to the previous char.",
	instructions = ".",
	tags = utility.flatten({ tag_index.deletion, tag_index.F }),
	input_template = "<target_register>dF<target_char>",
}

function DeleteF:new()
	local base = Delete:new()
	setmetatable(base, { __index = DeleteF })
	self.target_char = utility.calculate_target_char()
	return base
end

function DeleteF:activate()
	local line = utility.construct_char_line(self.target_char, self.cursor_center_pos - 10)
	self:delete_f(line, movements.F)
end

function DeleteF:instructions()
	return "Delete back to the char '"
		.. self.target_char
		.. "'"
		.. utility.construct_register_description(self.target_register)
		.. "."
end

return DeleteF
