local start_command = require("nvim-training.commands.command_start")
local analyze_command = require("nvim-training.commands.command_analyze")
local coverage = require("nvim-training.commands.command_coverage")
local recreate_md_command = require("nvim-training.commands.command_recreate_md")
local user_config = require("nvim-training.user_config")

local module = {
	Start = start_command,
	Stop = {
		execute = function(args)
			start_command.stop()
		end,
		complete = function()
			return {}
		end,
	},
	Analyse = analyze_command,
}
if user_config.dev_mode then
	module.ReCreateMD = recreate_md_command
	module.Coverage = coverage
end

return module
