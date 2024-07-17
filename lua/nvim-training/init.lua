local user_config = require("nvim-training.user_config")
local exposed_funcs = {}

function exposed_funcs.configure(args)
	for i, v in pairs(args) do
		user_config[i] = v
	end
end

function exposed_funcs.setup(args)
	print(
		"Calling setup in nvim-training has been deprecated. Removing it will work fine, some of the functionality is available with 'configure'"
	)
end

return exposed_funcs
