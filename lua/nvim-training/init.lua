local user_config = require("nvim-training.user_config")
local module = {}

local function generate_out_str(middle)
	return "Nvim-training: The config parameter "
		.. middle
		.. " is not supported. To ensure a smooth experience consider changing/removing it."
end

local function configure(args)
	for i, v in pairs(args) do
		if type(v) == "table" and string.find(i, "_args") then
			for ii, vv in pairs(v) do
				if not user_config[i][ii] then
					print(generate_out_str(i .. ":" .. ii))
				end

				user_config[i][ii] = vv
			end
		else
			if not user_config[i] then
				print((generate_out_str(i)))
			end
			user_config[i] = v
		end
	end

	os.execute("mkdir " .. tostring(user_config.logging_args.log_directory_path))
end

function module.configure(args)
	configure(args)
end

function module.setup(args)
	configure(args)
end

return module
