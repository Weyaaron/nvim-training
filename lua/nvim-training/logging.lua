local module = {}
local user_config = require("nvim-training.user_config")
local utility = require("nvim-training.utility")

local function display_to_user(msg, data)
	if user_config.logging_args.skip_all then
		return
	end
	local user_msg = msg .. ","
	for i, v in pairs(data) do
		user_msg = user_msg .. i .. ":" .. vim.inspect(v) .. ", "
	end
	print(user_msg)
end

local function log_to_file(msg, data)
	data.msg = msg
	data.timestamp = os.time()
	utility.append_json_to_file(user_config.logging_args.log_path, data)
end
function module.log(msg, data)
	if user_config.logging_args.skip_all then
		return
	end
	if user_config.logging_args.display_logs then
		display_to_user(msg, data)
	end
	log_to_file(msg, data)
end

function module.warn(msg, data)
	if user_config.logging_args.skip_all then
		return
	end
	if user_config.logging_args.display_warnings then
		display_to_user(msg, data)
	end
	data.level = "warn"
	log_to_file(msg, data)
end

return module
