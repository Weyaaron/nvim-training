local current_config = require("nvim-training.current_config")
local exposed_funcs = {}

function exposed_funcs.setup(args)
	for i, v in pairs(args) do
		current_config[i] = v
	end
end
return exposed_funcs
