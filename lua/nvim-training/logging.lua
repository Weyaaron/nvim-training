local module = {}
local user_config = require("nvim-training.user_config")
local utility = require("nvim-training.utility")

function display_to_user(msg, data)
	local user_msg = msg .. ","
	for i, v in pairs(data) do
		user_msg = user_msg .. i .. ":" .. vim.inspect(v) .. ", "
	end
	print(user_msg)
end
function module.log(msg, data)
	if user_config.logging_args.display_logs then
		display_to_user(msg, data)
	end
	data.msg = msg
	data.timestamp = os.time()
	data.level = "log"
	utility.append_json_to_file(user_config.logging_args.log_path, data)
end

function module.warn(msg, data)
	if user_config.logging_args.display_warnings then
		display_to_user(msg, data)
	end
	data.msg = msg
	data.timestamp = os.time()
	data.level = "warn"
	utility.append_json_to_file(user_config.logging_args.log_path, data)
end
return module
