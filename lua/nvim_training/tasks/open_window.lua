local Task = require("stelfnvim_training.task")
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
	local CloseWindowTask = require("stelfnvim_training.tasks.close_window")

	return CloseWindowTask
end

return OpenWindowTask
