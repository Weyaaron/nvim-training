local TaskScheduler = require("nvim-training.task_scheduler")

RepeatNSuccessScheduler = {}
RepeatNSuccessScheduler.__index = RepeatNSuccessScheduler
setmetatable(RepeatNSuccessScheduler, { __index = TaskScheduler })

function RepeatNSuccessScheduler:new(task_collections)
	local base = TaskScheduler:new(task_collections)
	setmetatable(base, { __index = RepeatNSuccessScheduler })

	base.success_limit = 5
	base.successes = 0
	base.task_counter = 1
	base.all_task = {}
	for i, task_collection_el in pairs(task_collections) do
		for ii, task_el in pairs(task_collection_el.tasks) do
			base.all_task[#base.all_task + 1] = task_el
		end
	end
	return base
end

function RepeatNSuccessScheduler:next(previous, result)
	if result then
		self.successes = self.successes + 1
	end
	if self.successes == self.success_limit then
		self.successes = 0
		self.task_counter = self.task_counter + 1
	end

	return self.all_task[self.task_counter % #self.all_task + 1]
end

return RepeatNSuccessScheduler
