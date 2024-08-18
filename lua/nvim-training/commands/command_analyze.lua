local utility = require("nvim-training.utility")
local parsing = require("nvim-training.utilities.parsing")
local module = {}

local stats_mod = require("nvim-training.command_analyze_subtypes")
local name_func_map = {
	All = stats_mod.all_stats,
	SuccessPercentage = stats_mod.succes_percentages,
	CounterPerTask = stats_mod.task_counter,
}
function module.execute(args)
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
			.. " Events has been parsed. (One task done is rougly two events).\n"
	)

	local matching_names = parsing.match_text_list_to_args(utility.get_keys(name_func_map), args)
	if #matching_names == 0 then
		print("You did not provide a subset of stats to be shown. All stats will be shown")
		matching_names = { "All" }
	end
	for i, name_el in pairs(matching_names) do
		name_func_map[name_el](events)
	end
end

function module.stop() end

function module.complete(arg_lead)
	local parsing = require("nvim-training.utilities.parsing")
	return parsing.complete_from_text_list(arg_lead, utility.get_keys(name_func_map))
end

return module
