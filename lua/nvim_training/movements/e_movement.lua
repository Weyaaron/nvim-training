local base_movement = require("lua/nvim_training/movements/base_movement")
local eMovement = base_movement:new()
eMovement.__index = eMovement
eMovement.base_args = { offset = 0 }

function eMovement:_execute_calculation()
	return { 5, 5 }
end

return eMovement
