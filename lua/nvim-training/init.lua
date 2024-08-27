local user_config = require("nvim-training.user_config")
local utility = require("nvim-training.utility")
local module = {}

function module.configure(args)
	for i, v in pairs(args) do
		user_config[i] = v
	end

	local base_path = user_config["base_path"]
	if user_config.enable_events then
		if not utility.exists(base_path) then
			print(
				tostring(base_path)
					.. " does not exist, will be created! If this path does not suit you, use 'configure' to set it."
			)
			os.execute("mkdir " .. tostring(base_path))
		end
	end
end

return module
