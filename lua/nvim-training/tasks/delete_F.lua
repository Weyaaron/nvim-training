local utility = require("nvim-training.utility")
local Delete = require("nvim-training.tasks.delete")
local movements = require("nvim-training.movements")

local DeleteF = {}
DeleteF.__index = DeleteF
setmetatable(DeleteF, { __index = Delete })
DeleteF.__metadata = {
	autocmd = "CursorMoved",
	desc = "Delete with the F-motion.",
	instructions = ".",
	tags = "deletion, F, horizontal",
}

function DeleteF:new()
	local base = Delete:new()
	setmetatable(base, { __index = DeleteF })
	self.target_char = utility.calculate_target_char()
	return base
end

function DeleteF:activate()
	local line = utility.construct_char_line(self.target_char, self.cursor_center_pos - 10)
	self:delete_with_left_f_movement(line, movements.F)
end

function DeleteF:instructions()
	return "Delete back to the char '" .. self.target_char .. "'."
end

return DeleteF
