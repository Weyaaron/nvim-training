local Task = require("src.task")
local MovementTask = Task:new()
MovementTask.__index = MovementTask
MovementTask.base_args = { autocmds = { "CursorMoved" } }

function Task:prepare()
	print("Prepared from Baseclass called, please implement it in the subclass!")
end

function Task:completed()
	print("Completed from Baseclass called, please implement it in the subclass!")
	return false
end

function Task:failed()
	print("Failed from Baseclass called, please implement it in the subclass!")
	return false
end

function Task:teardown()
	print("Teardown from Baseclass called, please implement it in the subclass!")
end

return MovementTask
