local utility = require("nvim-training.utility")
local Delete = require("nvim-training.tasks.delete")
local movements = require("nvim-training.movements")

local DeleteT = {}
DeleteT.__index = DeleteT
setmetatable(DeleteT, { __index = Delete })
DeleteT.__metadata = {
	autocmd = "CursorMoved",
	desc = "Delete with the movement T.",
	instructions = ".",
	tags = "movement, T, horizontal",
}

function DeleteT:new()
	local base = Delete:new()
	setmetatable(base, { __index = DeleteT })
	self.target_char = utility.calculate_target_char()
	return base
end

function DeleteT:activate()
	local line = utility.construct_char_line(self.target_char, self.cursor_center_pos - 10)
	self:delete_with_left_f_movement(line, movements.T)
end

function DeleteT:instructions()
	return "Delete back next to the char '" .. self.target_char .. "'."
end

return DeleteT
