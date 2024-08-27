local utility = require("nvim-training.utility")

local function calculate_task_percentages(events)
	local events_with_type_end = utility.filter_by_event_type(events, "task_end")
	local name_suc_fail_table = {}
	local result = {}
	for i, event_entry in pairs(events_with_type_end) do
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

	for i, event_tuple_entry in pairs(name_suc_fail_table) do
		local total_number = event_tuple_entry[1] + event_tuple_entry[2]
		local percentage = event_tuple_entry[1] / total_number
		result[i] = percentage
	end

	return result
end

local module = {}

function module.basic_stats(events)
	local task_starts = utility.filter_by_event_type(events, "task_start")
	local sessions = utility.filter_by_event_type(events, "session_start")

	local unique_events = utility.count_similar_events(events, function(a)
		local task_name = a["task_name"]
		if task_name then
			return task_name
		else
			return ""
		end
	end)

	local unique_task_started_counter = #utility.get_keys(unique_events)

	utility.append_lines_to_buffer(
		"You started a total of "
			.. tostring(#task_starts)
			.. " Tasks with "
			.. tostring(unique_task_started_counter)
			.. " types. \n"
	)
	utility.append_lines_to_buffer("You started a total of " .. tostring(#sessions) .. " Sessions.")
	local time_stamps = {}

	for i, v in pairs(sessions) do
		time_stamps[#time_stamps + 1] = v["time_stamp"]
	end
	local task_index = require("nvim-training.task_index")
	local total_tasks = #utility.get_keys(task_index)

	local percentage_started = unique_task_started_counter / total_tasks
	utility.append_lines_to_buffer(
		"You started "
			.. unique_task_started_counter
			.. " unique tasks, which is a percentage of "
			.. math.floor(percentage_started * 100)
			.. "% of all the "
			.. total_tasks
			.. " available."
	)
end

function module.succes_percentages(events)
	local percentages = calculate_task_percentages(events)

	local percentage_as_sortable = {}

	for i, v in pairs(percentages) do
		percentage_as_sortable[#percentage_as_sortable + 1] = { i, v }
	end
	table.sort(percentage_as_sortable, function(a, b)
		return a[2] > b[2]
	end)
	utility.append_lines_to_buffer("These are all the tasks you finished sorted by percentage of success:")
	for i, v in pairs(percentage_as_sortable) do
		utility.append_lines_to_buffer(tostring(v[1]) .. ": " .. tostring(v[2] * 100) .. "%")
	end
end

function module.task_counter(events)
	local events_with_task_name = utility.filter_by_event_type(events, "task_end")
	local unique_events = utility.count_similar_events(events_with_task_name, function(a)
		local task_name = a["task_name"]
		if task_name then
			return task_name
		else
			return ""
		end
	end)
	utility.append_lines_to_buffer("These are how often you finished the tasks you started:")

	local unique_as_sortable = {}

	for i, v in pairs(unique_events) do
		unique_as_sortable[#unique_as_sortable + 1] = { i, v }
	end

	local function sort(a, b)
		return a[2] > b[2]
	end
	table.sort(unique_as_sortable, sort)
	for i, v in pairs(unique_as_sortable) do
		utility.append_lines_to_buffer(tostring(v[1]) .. ": " .. tostring(v[2]))
	end
end
function module.all_stats(events)
	module.basic_stats(events)
	module.succes_percentages(events)
	module.task_counter(events)
end

return module
