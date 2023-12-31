local Task = require("nvim_training.task")
local CloseWindowTask = Task:new()
CloseWindowTask.base_args = { tags = { "window", "ui" }, autocmds = { "WinClosed" }, desc = "Close a window" }

function CloseWindowTask:setup()
	self.instruction = "Close a window"
	vim.cmd(":vsplit")
end

function CloseWindowTask:completed()
	return true
end

function CloseWindowTask:failed()
	return false
end

function CloseWindowTask:teardown() end

return CloseWindowTask
