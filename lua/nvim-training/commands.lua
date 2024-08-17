local start_command = require("nvim-training.commands.command_start")
local analyze_command = require("nvim-training.commands.command_analyze")
local recreate_md_command = require("nvim-training.commands.command_recreate_md")
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
	ReCreateMD = recreate_md_command,
	Analyse = analyze_command,
}
return subcommand_tbl
