local Task = require("lua.task")
local CloseWindowTask = Task:new()

CloseWindowTask.base_args = { tags = { "window", "ui" }, autocmds = { "Winclosed" }, desc = "Close a window" }

function CloseWindowTask:prepare() end

function CloseWindowTask:completed()
	return true
end

function CloseWindowTask:failed()
	return false
end

function CloseWindowTask:teardown() end

function CloseWindowTask:first()
	local OpenWindowTask = require("lua.tasks.open_window")
	return OpenWindowTask
end

return CloseWindowTask
