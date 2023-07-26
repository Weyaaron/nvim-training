local Task = require("lua.task")
local OpenWindowTask = Task:new()

OpenWindowTask.base_args = { tags = { "window", "ui" }, autocmds = { "Winenter" }, desc = "Create a new window" }

function OpenWindowTask:prepare() end

function OpenWindowTask:completed()
	return true
end

function OpenWindowTask:failed()
	return false
end

function OpenWindowTask:teardown() end

function OpenWindowTask:next()
	local CloseWindowTask = require("lua.tasks.close_window")

	return CloseWindowTask
end

return OpenWindowTask
