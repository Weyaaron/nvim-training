local utility = require("nvim-training.utility")
local Task = {}
Task.__index = Task
Task.__metadata = {}

function Task:new()
	local base = {}
	setmetatable(base, Task)
	--This is usefull for such a huge swath of tasks that this is worthwile
	base.counter = utility.calculate_counter()
	return base
end

function Task:activate() end

function Task:metadata()
	return self.__metadata
end
function Task:deactivate(autocmd_callback_data) end

function Task:instructions()
	return self.__metadata.instructions
end

function Task:construct_optional_header_args()
	--This might someday be merged with description, but remains a special case for the time being.
	return {}
end

return Task
