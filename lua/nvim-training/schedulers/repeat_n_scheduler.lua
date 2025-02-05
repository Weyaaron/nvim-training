local TaskScheduler = require("nvim-training.task_scheduler")
local user_config = require("nvim-training.user_config")
local task_index = require("nvim-training.task_index")

RepeatNScheduler = {}
RepeatNScheduler.__index = RepeatNScheduler
setmetatable(RepeatNScheduler, { __index = TaskScheduler })

function RepeatNScheduler:new(task_collections)
	local base = TaskScheduler:new(task_collections)
	setmetatable(base, { __index = RepeatNScheduler })

	base.task_counter = 0
	base.full_task_name_list = {}
	for i, task_collection_el in pairs(task_collections) do
		for ii, task_el in pairs(task_collection_el.tasks) do
			for iii = 1, user_config.scheduler_args.repetitions do
				base.full_task_name_list[#base.full_task_name_list + 1] = task_el.name
			end
		end
	end

	-- This sort ensures that tasks like MoveT,MoveT stay reasonably sorted
	table.sort(base.full_task_name_list, function(a, b)
		if string.lower(a) == string.lower(b) then
			return a < b
		end
		return string.lower(a) < string.lower(b)
	end)
	return base
end

function RepeatNScheduler:next(previous, result)
	self.task_counter = self.task_counter + 1
	local choosen_task = task_index[self.full_task_name_list[self.task_counter]]
	return choosen_task
end

return RepeatNScheduler
