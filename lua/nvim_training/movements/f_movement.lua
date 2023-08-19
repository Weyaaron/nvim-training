local base_movement = require("lua/nvim_training/movements/base_movement")
local fMovement = base_movement:new()
local utility = require("lua.nvim_training.utility")
fMovement.__index = fMovement

fMovement.base_args = { target_char = "" }

function fMovement:_execute_calculation() end

return fMovement
