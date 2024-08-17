local user_config = require("nvim-training.user_config")
local exposed_funcs = {}

--- Check if a file or directory exists in this path
function exists(file)
	local ok, err, code = os.rename(file, file)
	if not ok then
		if code == 13 then
			-- Permission denied, but it exists
			return true
		end
	end
	return ok, err
end

--- Check if a directory exists in this path
function isdir(path)
	-- "/" works on both Unix and Windows
	return exists(path .. "/")
end

function exposed_funcs.configure(args)
	for i, v in pairs(args) do
		user_config[i] = v
	end

	local base_path = user_config["base_path"]
	if not exists(base_path) then
		print(
			tostring(base_path)
				.. " does not exist, will be created! If this path does not suit you, use 'configure' to set it."
		)
		os.execute("mkdir " .. tostring(base_path))
	end
end

function exposed_funcs.setup(args)
	print(
		"Calling setup in nvim-training has been deprecated. Removing it will work fine, some of the functionality is available with 'configure'"
	)
end

return exposed_funcs
