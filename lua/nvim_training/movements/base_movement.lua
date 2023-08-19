local Movement = {}
Movement.__index = Movement

Movement.base_args = {}

local utility = require("nvim_training.utility")
function Movement:new(custom_args)
	self.__index = self
	local base = {}
	if not custom_args then
		custom_args = self.base_args
	end
	for i, v in pairs(self.base_args) do
		if not custom_args[i] then
			base[i] = v
		end
	end
	setmetatable(base, self)

	for i, v in pairs(custom_args) do
		base[i] = v
	end

	self.buffer_as_list = utility.construct_linked_list()
	return base
end
function Movement:_execute_calculation()
	return { 5, 9 }
end
function Movement:_prepare_calculation() end

function Movement:calculate_cursor_x_y()
	self:_prepare_calculation()
	return self:_execute_calculation()
end

return Movement
