if vim.g.loaded_training == 1 then
	print("Already loaded")
	return
end
vim.g.loaded_training = 1

local function my_cmd(opts)
	local subcommand_tbl = require("nvim-training.commands")
	local fargs = opts.fargs
	local subcommand_key = fargs[1]
	-- Get the subcommand's arguments, if any
	local args = #fargs > 1 and vim.list_slice(fargs, 2, #fargs) or {}
	local subcommand = subcommand_tbl[subcommand_key]
	if not subcommand then
		vim.notify("Training subcommand : " .. subcommand_key, vim.log.levels.ERROR)
		return
	end
	subcommand.execute(args, opts)
end

-- NOTE: the options will vary, based on your use case.
vim.api.nvim_create_user_command("Training", my_cmd, {
	nargs = "+",
	desc = "Train your muscle memory.",
	complete = function(arg_lead, cmdline, _)
		local subcommand_tbl = require("nvim-training.commands")
		-- Get the subcommand.
		local subcmd_key, subcmd_arg_lead = cmdline:match("^['<,'>]*Training[!]*%s(%S+)%s(.*)$")
		if subcmd_key and subcmd_arg_lead and subcommand_tbl[subcmd_key] and subcommand_tbl[subcmd_key].complete then
			-- The subcommand has completions. Return them.
			return subcommand_tbl[subcmd_key].complete(subcmd_arg_lead)
		end
		-- Check if cmdline is a subcommand
		if cmdline:match("^['<,'>]*Training[!]*%s+%w*$") then
			-- Filter subcommands that match
			local subcommand_keys = vim.tbl_keys(subcommand_tbl)
			return vim.iter(subcommand_keys)
				:filter(function(key)
					return key:find(arg_lead) ~= nil
				end)
				:totable()
		end
	end,
	bang = true, -- If you want to support ! modifiers
})
