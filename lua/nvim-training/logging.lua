local module = {}
local user_config = require("nvim-training.user_config")
local utility = require("nvim-training.utility")

local function display_to_user(msg, data)
	if user_config.logging_args.enable_logging then
		local user_msg = msg .. ","
		for i, v in pairs(data) do
			user_msg = user_msg .. i .. ":" .. vim.inspect(v) .. ", "
		end
		print(user_msg)
	end
end

local function log_to_file(msg, data)
	if user_config.logging_args.enable_logging and utility.check_for_file_existence(full_path) then
		data.msg = msg
		data.timestamp = os.time()
		local full_path = user_config.logging_args.log_directory_path .. user_config.logging_args.log_file_path
		local file = io.open(full_path, "a")

		table.sort(data)

		local data_as_str = vim.json.encode(data)

		file:write(data_as_str .. "\n")
		file:close()
	end
end
function module.log(msg, data)
	if user_config.logging_args.enable_logging then
		if user_config.logging_args.display_logs then
			display_to_user(msg, data)
		end
		log_to_file(msg, data)
	end
end

function module.warn(msg, data)
	if user_config.logging_args.enable_logging then
		if user_config.logging_args.display_warnings then
			display_to_user(msg, data)
		end
		data.level = "warn"
		log_to_file(msg, data)
	end
end

return module
