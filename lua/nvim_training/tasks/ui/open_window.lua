local Task = require("nvim_training.task")
local OpenWindowTask = Task:new()

OpenWindowTask.base_args = { tags = { "window", "ui" }, autocmds = { "WinNew" }, desc = "Create a new window" }

function OpenWindowTask:prepare() end

function OpenWindowTask:completed()
	return true
end

function OpenWindowTask:failed()
	return false
end

function OpenWindowTask:teardown() end

return OpenWindowTask
