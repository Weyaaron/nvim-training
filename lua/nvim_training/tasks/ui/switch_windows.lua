local Task = require("nvim_training.task")
local SwitchWindowTask = Task:new()
SwitchWindowTask.base_args = { tags = { "window", "ui" }, autocmds = { "WinEnter" }, desc = "Switch to new a window" }

function SwitchWindowTask:prepare()
	self.desc = "Switch to another window"
end

function SwitchWindowTask:completed()
	return false
end

function SwitchWindowTask:failed()
	return false
end

function SwitchWindowTask:teardown() end

return SwitchWindowTask
