local start_command = require("nvim-training.commands.command_start")
local analyze_command = require("nvim-training.commands.command_analyze")
local recreate_md_command = require("nvim-training.commands.command_recreate_md")

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
	-- ReCreateMD = recreate_md_command,
	Analyse = analyze_command,
}
return module
