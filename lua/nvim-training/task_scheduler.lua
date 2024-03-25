local TaskScheduler = {}
TaskScheduler.__index = TaskScheduler

function TaskScheduler:new(args)
	local base = args or {}
	setmetatable(base, { __index = self })

	return base
end

function TaskScheduler:next()
	return
end

return TaskScheduler


-- function (all_tasks, prev_task, prev_task_res, 
