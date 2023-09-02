-- luacheck: globals vim

local TaskResult = {}
TaskResult.__index = TaskResult

function TaskResult:new(task, completed, failed)
	local base = {}
	setmetatable(base, { __index = self })
	base.task = task
	base._completed = completed
	base._failed = failed

	return base
end
function TaskResult:completed()
	return self._completed and not self._failed
end
function TaskResult:failed()
	return self._failed and not self._completed
end
return TaskResult
