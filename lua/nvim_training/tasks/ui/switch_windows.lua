local Task = require("nvim_training.task")
local SwitchWindowTask = Task:new()
SwitchWindowTask.base_args = { tags = { "window", "ui" }, autocmds = { "WinEnter" }, desc = "Switch to new a window" }

function SwitchWindowTask:prepare()
	print("Prep of switch window called")
	self.desc = "Switch to another window"
end

function SwitchWindowTask:completed()
	return true
end

function SwitchWindowTask:failed()
	return false
end

function SwitchWindowTask:teardown() end

function SwitchWindowTask:previous()
	local OpenWindowTask = require("lua.nvim_training.tasks.ui.open_window")

	return OpenWindowTask
end

function SwitchWindowTask:next()
	local CloseWindowTask = require("lua.nvim_training.tasks.ui.close_window")

	return CloseWindowTask
end


return SwitchWindowTask
