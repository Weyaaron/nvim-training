local Task = require("plugin.src.task")
local CreateWindowTask = Task:new()

CreateWindowTask.base_args = { tags = { "window", "ui" }, autocmds = { "Winenter" }, desc = "Create a new window" }

function CreateWindowTask:prepare() end

function CreateWindowTask:completed()
	return true
end

function CreateWindowTask:failed()
	return false
end

function CreateWindowTask:teardown() end

return CreateWindowTask
