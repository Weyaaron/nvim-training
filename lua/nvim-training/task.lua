local Task = {}
Task.__index = Task

function Task:new(args)
	local base = args or {}
	setmetatable(base, { __index = self })

	return base
end

function Task:setup() end

function Task:teardown(autocmd_callback_data) end
function Task:description()
	return "Not implemented yet"
end

return Task
