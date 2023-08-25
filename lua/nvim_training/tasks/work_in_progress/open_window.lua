local Task = require("nvim_training.task")
local OpenWindowTask = Task:new()

OpenWindowTask.base_args = { tags = { "window", "ui" }, autocmds = { "WinNew" }, desc = "Create a new window" }

function OpenWindowTask:setup() end

function OpenWindowTask:completed()
	return true
end

function OpenWindowTask:failed()
	return false
end

function OpenWindowTask:teardown()
	vim.cmd(":q")
end

return OpenWindowTask
