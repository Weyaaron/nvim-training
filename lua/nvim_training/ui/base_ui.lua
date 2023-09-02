local Window = require("nvim_training.window")

local BaseUI = {}
BaseUI.__index = BaseUI

function BaseUI:new(width, height, x, y)
	local base = {}
	setmetatable(base, { __index = self })
	base.x = x
	base.y = y
	base.height = height
	base.width = width
	base.window = Window:new(width, height, x, y)
	return base
end

function BaseUI:display(current_task_sequence) end

return BaseUI
