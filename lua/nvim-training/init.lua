local user_config = require("nvim-training.user_config")
local utility = require("nvim-training.utility")
local module = {}

function module.check_path(base_path)
	return user_config.enable_events and utility.exists(base_path)
end

local function configure(args)
	for i, v in pairs(args) do
		user_config[i] = v
	end
	if not module.check_path(user_config.base_path) then
		print(
			tostring(user_config.base_path)
				.. " does not exist. Creation will be attempted! If this path does not suit you, use 'configure' to set it."
		)
		os.execute("mkdir " .. tostring(user_config.base_path))
	end
end

function module.configure(args)
	configure(args)
end

function module.setup(args)
	configure(args)
end

return module
