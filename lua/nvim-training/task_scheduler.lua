local TaskScheduler = {}
TaskScheduler.__index = TaskScheduler

function TaskScheduler:new(initial_tasks, kwargs)
	local base = {}
	setmetatable(base, { __index = TaskScheduler })
	base.initial_tasks = initial_tasks
	base.kwargs = kwargs
	base.default_kwargs = {}

	return base
end

function TaskScheduler:next(previous, result)
	return
end

function TaskScheduler:accepted_kwargs()
	return self.default_kwargs
end

return TaskScheduler
