local module = {}
local user_config = require("nvim-training.user_config")

function write_to_file(data)
	print(user_config.logging_args.log_path)
	local file = io.open(user_config.logging_args.log_path, "a")

	table.sort(data)

	local data_as_str = vim.json.encode(data)

	file:write(data_as_str .. "\n")
	file:close()
end

function module.log(msg, data)
	print(user_config.logging_args)
	data.msg = msg
	data.timestamp = os.time()
	if user_config.logging_args.display_logs then
		local user_msg = msg
		for i, v in pairs(data) do
			user_msg = user_msg .. vim.inspect(v)
		end
		print(user_msg)
	end
	write_to_file(data)
end

function module.warn(msg, data)
	print(user_config.logging_args)
end
return module
