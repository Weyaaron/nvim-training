


local movement = require('lua/nvim_training/movements/base_movement')
local TestMovement = movement:new()
TestMovement.__index =TestMovement

TestMovement.base_args = {}

function TestMovement:_execute_calculation()
	local x = math.random(3,10)
	local y = math.random(3,7)
return {x,y}

end
return TestMovement

