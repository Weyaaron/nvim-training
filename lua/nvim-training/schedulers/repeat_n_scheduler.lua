local TaskScheduler = require("nvim-training.task_scheduler")
local user_config = require("nvim-training.user_config")

RepeatNScheduler = {}
RepeatNScheduler.__index = RepeatNScheduler
setmetatable(RepeatNScheduler, { __index = TaskScheduler })

function RepeatNScheduler:new(task_collections)
	local base = TaskScheduler:new(task_collections)
	setmetatable(base, { __index = RepeatNScheduler })

	base.current_task_count = 0
	base.task_counter = 1
	base.all_task = {}
	for i, task_collection_el in pairs(task_collections) do
		for ii, task_el in pairs(task_collection_el.tasks) do
			base.all_task[#base.all_task + 1] = task_el
		end
	end
	-- Sorts table elements in a given order, in-place, from table[1] to table[n], where n is the length of the table. If comp is given, then it must be a function that receives two table elements, and returns true when the first is less than the second (so that not comp(a[i+1],a[i]) will be true after the sort). If comp is not given, then the standard Lua operator < is used instead.
	table.sort(base.all_task, function(a, b)
		return a.name < b.name
	end)
	return base
end

function RepeatNScheduler:next(previous, result)
	self.current_task_count = self.current_task_count + 1
	if self.current_task_count == user_config.scheduler_args.repetitions then
		self.current_task_count = 0
		self.task_counter = self.task_counter + 1
	end

	return self.all_task[self.task_counter % #self.all_task + 1]
end

return RepeatNScheduler
