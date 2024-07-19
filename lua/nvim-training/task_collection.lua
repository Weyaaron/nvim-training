local task_index = require("nvim-training.task_index")
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

function TaskCollection:render_markdown() end

return TaskCollection
