local user_config = require("nvim-training.user_config")
local utility = require("nvim-training.utility")
local module = {}

module.check = function()
	vim.health.start("Logging/Events")

	--Todo: Think through wether this is fine with health-check running late

	if user_config.logging_args.enable_logging then
		local existence_check = utility.check_for_file_existence(user_config.logging_args.log_directory_path)
		if not existence_check then
			vim.health.error(
				"The logging directory "
					.. user_config.logging_args.log_directory_path
					.. " does not exist. Logging will be skipped."
			)
		else
			vim.health.ok("Logging is enabled and the directory exists.")
		end
	else
		vim.health.ok("Logging is not enabled.")
	end
end

return module
