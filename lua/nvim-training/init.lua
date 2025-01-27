local user_config = require("nvim-training.user_config")
local module = {}

local function generate_out_str(middle)
	return "The config parameter " .. middle .. " is not supported. To ensure a smooth experience consider changing/removing it."
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
				print(print(generate_out_str(i)))
			end
			user_config[i] = v
		end
	end

	local paths = {
		user_config.logging_args.log_directory_path .. user_config.logging_args.log_file_path,
		-- user_config.event_args.event_diretory_path .. user_config.event_args.event_file_path, --Todo: Reintroduce
	}
	for i, v in pairs(paths) do
		os.execute("mkdir " .. tostring(v))
	end
end

function module.configure(args)
	configure(args)
end

function module.setup(args)
	configure(args)
end

return module
