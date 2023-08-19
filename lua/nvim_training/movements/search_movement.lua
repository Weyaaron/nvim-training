local base_movement = require("lua/nvim_training/movements/base_movement")
local SearchMovement = base_movement:new()
SearchMovement.__index = SearchMovement

SearchMovement.base_args = { offset = 0 }

function SearchMovement:_execute_calculation() end

return SearchMovement
