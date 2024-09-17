local TaskScheduler = {}
TaskScheduler.__index = TaskScheduler

function TaskScheduler:new(task_collections)
	local base = {}
	setmetatable(base, { __index = TaskScheduler })
	base.task_collections = task_collections

	return base
end

function TaskScheduler:next(previous, result) end

return TaskScheduler
