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

local stats_map = {}

local function basic_stats(events)
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
		"You started"
			.. unique_task_started_counter
			.. " unique tasks, which is a percentage of "
			.. percentage_started
			.. " of all the "
			.. total_tasks
			.. " available."
	)
end

local function succes_percentages(events)
	local percentages = calculate_task_percentages(events)
	table.sort(percentages)
	utility.append_lines_to_buffer("These are all the tasks you finished sorted by percentage of success:")
	for i, v in pairs(percentages) do
		utility.append_lines_to_buffer(tostring(i) .. ": " .. tostring(v * 100) .. "%")
	end
end

local function task_counter(events)
	local unique_events = utility.count_similar_events(events, function(a)
		local task_name = a["task_name"]
		if task_name then
			return task_name
		else
			return ""
		end
	end)
	utility.append_lines_to_buffer("These are how often you finished the tasks you started:")
	table.sort(unique_events)
	for i, v in pairs(unique_events) do
		if #i > 0 then --This catches events of the wrong type
			utility.append_lines_to_buffer(tostring(i) .. ": " .. tostring(v))
		end
	end
end
function stats_map.all_stats()
	local events = utility.load_all_events()
	basic_stats(events)
	succes_percentages(events)
	task_counter(events)
end

return stats_map
