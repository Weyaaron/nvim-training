local utility = require("nvim-training.utility")
local funcs = {}

function funcs.execute(args, opts)
	vim.cmd("e results.txt")
	-- local events = utility.load_all_events()
	--
	-- local total_task_starts = utility.count_events_of_type(events, "task_start")
	-- local total_task_ends = utility.count_events_of_type(events, "task_end")

	funcs.task_percentages()

	-- utility.append_lines_to_buffer("You started a total of " .. tostring(total_task_starts) .. "Tasks. \n")
	-- for i, v in pairs(events) do
	-- 	utility.append_lines_to_buffer(vim.inspect(v) .. "\n")
	-- end
end

function funcs.task_percentages()
	local events = utility.load_all_events()
	local total_task_ends = utility.count_events_of_type(events, "task_end")
	local name_suc_fail_table = {}
	for i, event_entry in pairs(events) do
		local name = event_entry["task_name"]
		if name then
			if not name_suc_fail_table[name] then
				name_suc_fail_table[name] = { 0, 0 }
			end

			if event_entry["result"] then
				name_suc_fail_table[name][1] = name_suc_fail_table[name][1] + 1
			else
				name_suc_fail_table[name][2] = name_suc_fail_table[name][2] + 1
			end
		end
	end
	table.sort(name_suc_fail_table)
	print(vim.inspect(name_suc_fail_table))

	for i, event_tuple_entry in pairs(name_suc_fail_table) do
		local total_number = event_tuple_entry[1] + event_tuple_entry[2]
		local percentage = event_tuple_entry[1] / total_number
		print(i, percentage)
	end
end

function funcs.stop() end

function funcs.complete(arg_lead) end

return funcs
