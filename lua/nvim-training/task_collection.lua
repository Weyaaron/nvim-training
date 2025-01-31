local task_index = require("nvim-training.task_index")
local TaskCollection = {}
TaskCollection.__index = TaskCollection

function TaskCollection:new(collection_desc)
	local base = {}
	setmetatable(base, TaskCollection)
	base.name = collection_desc[1]
	base.desc = collection_desc[2]
	base.task_names = collection_desc[3]

	base.tasks = {}
	for key, value in pairs(base.task_names) do
		local resolved_task = task_index[value]
		if resolved_task == nil then
			print(
				"Unable to load '"
					.. value
					.. "' into collection '"
					.. name
					.. "'. Please check spelling/report an issue!"
			)
		else
			base.tasks[#base.tasks + 1] = resolved_task
		end
	end
	return base
end

function TaskCollection:render_markdown()
	local lines = {}

	local sorted_task_names = self.task_names
	table.sort(sorted_task_names, function(a, b)
		return string.lower(a) < string.lower(b)
	end)

	for i, task_name in pairs(sorted_task_names) do
		--We do not do this as a class method since its a pain to gather all the pieces inside the task
		local current_task = task_index[task_name]:new()
		local tags_of_current_task = current_task.__metadata.tags

		table.sort(tags_of_current_task, function(a, b)
			return a:lower() < b:lower()
		end)
		local pieces = { task_name, current_task.__metadata.desc }
		pieces[#pieces + 1] = table.concat(tags_of_current_task, ", ")

		if current_task.__metadata then
			pieces[#pieces + 1] = current_task.__metadata.notes
		end
		lines[#lines + 1] = "|" .. table.concat(pieces, " | ") .. " |"
	end

	local str_result = table.concat(lines, "\n")
	str_result = str_result:gsub("%s%s", " ")
	return str_result
end

return TaskCollection
