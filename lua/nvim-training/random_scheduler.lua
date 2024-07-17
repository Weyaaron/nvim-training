local TaskScheduler = require("nvim-training.task_scheduler")

RandomScheduler = TaskScheduler:new()

function RandomScheduler:new(task_collections, kwargs)
	local default_kwargs = {}
	if not kwargs then
		kwargs = default_kwargs
	end

	local base = TaskScheduler:new(task_collections, kwargs)
	setmetatable(base, { __index = RandomScheduler })

	return base
end

function RandomScheduler:next(previous, result)
	local random_task_collection = self.task_collections[math.random(#self.task_collections)]
	local rand_int = math.random(#random_task_collection.tasks)
	return random_task_collection.tasks[rand_int]
end

return RandomScheduler
