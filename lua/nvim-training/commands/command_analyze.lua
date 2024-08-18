local utility = require("nvim-training.utility")
local task_index = require("nvim-training.task_index")
local funcs = {}

local stats_map = { "All", "%Success", "CounterPerTask" }

function funcs.execute(args, opts)
	vim.cmd("e results.txt")
	vim.api.nvim_buf_set_lines(0, 0, vim.api.nvim_buf_line_count(0), false, {})

	funcs.task_percentages()

	local utility = require("nvim-training.utility")
	-- utility.append_lines_to_buffer("You started a total of " .. tostring(total_task_starts) .. "Tasks. \n")
	local events = utility.load_all_events()

	if #events == 0 then
		print(
			"Unable to load any events. Please change the config path/use this plugin some time to create some events"
		)

		utility.append_lines_to_buffer(
			"Unable to load any events. Please change the config path/use this plugin some time to create some events"
		)
		do
			return
		end
	end

	utility.append_lines_to_buffer(
		"To generate these stats, a total of "
			.. tostring(#events)
			.. " Events has been parsed. (One task done is rougly two events). "
	)

	local stats_mod = require("nvim-training.command_analyze_subtypes")
	stats_mod.all_stats()
end

function funcs.stop() end

function funcs.complete(arg_lead)
	--Todo: Unify the matching
	local parsing = require("nvim-training.utilities.parsing")
	return parsing.complete_from_text_list(arg_lead, stats_map)
end

return funcs
