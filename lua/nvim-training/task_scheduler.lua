local TaskScheduler = {}
TaskScheduler.__index = TaskScheduler

function TaskScheduler:new(task_collections, kwargs)
	local base = {}
	setmetatable(base, { __index = TaskScheduler })
	base.task_collections = task_collections
	base.kwargs = kwargs
	base.default_kwargs = {}

	return base
end

function TaskScheduler:next(previous, result) end

function TaskScheduler:accepted_kwargs()
	return self.default_kwargs
end

return TaskScheduler
