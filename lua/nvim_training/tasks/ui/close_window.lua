local Task = require("nvim_training.task")
local CloseWindowTask = Task:new()
CloseWindowTask.base_args = { tags = { "window", "ui" }, autocmds = { "WinClosed" }, desc = "Close a window" }

function CloseWindowTask:prepare()
	self.desc = "Close a window"
end

function CloseWindowTask:completed()
	return true
end

function CloseWindowTask:failed()
	return false
end

function CloseWindowTask:teardown() end

function CloseWindowTask:previous()
	local OpenWindowTask = require("lua.nvim_training.tasks.ui.open_window")

	return OpenWindowTask
end

return CloseWindowTask
