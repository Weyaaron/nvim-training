local TaskScheduler = require("nvim-training.task_scheduler")

RandomScheduler = TaskScheduler:new()

function RandomScheduler:new(initial_tasks, kwargs)
	local default_kwargs = {}
	if not kwargs then
		kwargs = default_kwargs
	end

	local base = TaskScheduler:new(initial_tasks, kwargs)
	setmetatable(base, { __index = RandomScheduler })
	base.remaining_tasks = initial_tasks

	return base
end

function RandomScheduler:next(previous, result)
	return self.initial_tasks[math.random(#self.initial_tasks)]
end

return RandomScheduler
