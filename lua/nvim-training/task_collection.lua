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
		local tag_str = current_task.__metadata.tags or "not given"
		local tag_pieces = utility.split_str(tag_str, ",")

		local tag_pieces_that_are_suitable = {}
		local dup_table = {}
		for ii, v in pairs(tag_pieces) do
			if #v > 1 and not ((v == " ") or (v == "  ")) and dup_table[v] == nil then
				tag_pieces_that_are_suitable[#tag_pieces_that_are_suitable + 1] = utility.trim(v)
				dup_table[v] = v
			end
		end
		table.sort(tag_pieces_that_are_suitable, function(a, b)
			return a:lower() < b:lower()
		end)

		print(vim.inspect(tag_pieces_that_are_suitable))
		local pieces = { task_name, current_task.__metadata.desc }
		pieces[#pieces + 1] = table.concat(tag_pieces_that_are_suitable, ", ")

		if current_task.__metadata then
			pieces[#pieces + 1] = current_task.__metadata.notes
		end
		-- lines[#lines + 1] = "| " .. task_name .. task_index[task_name]:new():render_markdown()
		lines[#lines + 1] = "|" .. table.concat(pieces, " | ") .. " |"
	end

	local str_result = table.concat(lines, "\n")
	str_result = str_result:gsub("%s%s", " ")
	return str_result
end

return TaskCollection
