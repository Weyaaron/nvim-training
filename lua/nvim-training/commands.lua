local start_command = require("nvim-training.command_start")
local analyze_command = require("nvim-training.command_analyze")
local subcommand_tbl = {
	Start = start_command,
	Stop = {
		execute = function(args, opts)
			start_command.stop()
		end,
		complete = function(subcmd_arg_lead)
			return {}
		end,
	},
	--This will be part of a later release
	-- Analyse = analyze_command,
}
return subcommand_tbl
