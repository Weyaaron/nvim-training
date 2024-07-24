local task_index = require("nvim-training.task_index")
local utility = require("nvim-training.utility")
local TaskCollection = {}
TaskCollection.__index = TaskCollection

function TaskCollection:new(name, desc, task_names)
	local base = {}
	setmetatable(base, TaskCollection)
	base.name = name
	base.desc = desc
	base.task_names = task_names

	base.tasks = {}
	for key, value in pairs(task_names) do
		local new_val = task_index[value]
		if not new_val then
			print(
				"Unable to load '"
					.. value
					.. "' into collection '"
					.. name
					.. "'. Please check spelling/report an issue!"
			)
		end
		base.tasks[#base.tasks + 1] = task_index[value]
	end
	return base
end

function TaskCollection:render_markdown(table_header)
	local header = "## " .. self.name .. " (" .. self.desc .. ")\n" .. table_header
	local lines = {}

	for i, task_name in pairs(self.task_names) do
		--We do not do this as a class method since its a pain to gather all the pieces inside the task
		local current_task = task_index[task_name]:new()
		local tag_str = current_task.__metadata.tags or "not given"
		local tag_pieces = utility.split_str(tag_str, ",")
		table.sort(tag_pieces)

		local pieces = { task_name, current_task.__metadata.desc }
		pieces[#pieces + 1] = table.concat(tag_pieces, ", ")

		if current_task.__metadata then
			pieces[#pieces + 1] = current_task.__metadata.notes
		end
		-- lines[#lines + 1] = "| " .. task_name .. task_index[task_name]:new():render_markdown()
		lines[#lines + 1] = "|" .. table.concat(pieces, " | ") .. " |"
	end

	table.sort(lines)
	local result = { header }

	for i, v in pairs(lines) do
		result[#result + 1] = v
	end

	return table.concat(result, "\n")
end

return TaskCollection
