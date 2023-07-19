local Task = {}

function Task:new()
	local newObj = { desc = nil, autocmds = { "CursorMoved" }, minimal_level = 1, abr = "ABLT" }
	self.__index = self
	setmetatable(newObj, self)
	return newObj
end

function Task:completed()
	return false
end

function Task:failed()
	return false
end

function Task:teardown() end

return Task
