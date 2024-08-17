local TaskScheduler = require("nvim-training.task_scheduler")

RepeatNScheduler = {}
RepeatNScheduler.__index = RepeatNScheduler
setmetatable(RepeatNScheduler, { __index = TaskScheduler })

function RepeatNScheduler:new(task_collections, kwargs)
	local default_kwargs = {}
	if not kwargs then
		kwargs = default_kwargs
	end

	local base = TaskScheduler:new(task_collections, kwargs)
	setmetatable(base, { __index = RepeatNScheduler })

	--Todo: Add header extension for schedulers

	base.success_limit = 2
	base.current_task_count = 0
	base.task_counter = 1
	base.all_task = {}
	for i, task_collection_el in pairs(task_collections) do
		for ii, task_el in pairs(task_collection_el.tasks) do
			base.all_task[#base.all_task + 1] = task_el
		end
	end
	return base
end

function RepeatNScheduler:next(previous, result)
	self.current_task_count = self.current_task_count + 1
	if self.current_task_count == self.success_limit then
		self.current_task_count = 0
		self.task_counter = self.task_counter + 1
	end

	return self.all_task[self.task_counter % #self.all_task + 1]
end

return RepeatNScheduler
