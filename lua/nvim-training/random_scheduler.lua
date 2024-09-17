local TaskScheduler = require("nvim-training.task_scheduler")

RandomScheduler = {}
RandomScheduler.__index = RandomScheduler
setmetatable(RandomScheduler, { __index = TaskScheduler })

function RandomScheduler:new(task_collections)
	local base = TaskScheduler:new(task_collections)
	setmetatable(base, { __index = RandomScheduler })

	return base
end

function RandomScheduler:next(previous, result)
	local random_task_collection = self.task_collections[math.random(#self.task_collections)]
	local rand_int = math.random(#random_task_collection.tasks)
	return random_task_collection.tasks[rand_int]
end

return RandomScheduler
