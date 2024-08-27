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
	--Not quite sure if this is the right choice....
	vim.cmd("!rm results.txt")
	vim.cmd("e results.txt")
	vim.api.nvim_buf_set_lines(0, 0, 0, false, {})
	vim.cmd("sil write!")
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

	vim.api.nvim_buf_set_lines(0, 0, 0, false, {

		"This mode is currently in a beta and subject to change. Feedback by opening an issue is appreciated.",
	})
	vim.cmd("sil write!")
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
	return parsing.complete_from_text_list(arg_lead, utility.get_keys(name_func_map))
end

return module
