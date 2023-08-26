-- luacheck: globals vim

local Round = {}
Round.__index = Round

function Round:new(task_pool)
	local base = {
		task_length = 5,
		task_index = 1,
	}
	setmetatable(base, { __index = self })
	base.task_pool = task_pool
	base.status_list = {}
	return base
end

function Round:setup()
	print("New Round started")
	self.task_sequence = {}

	for _ = 1, self.task_length do
		local current_next_task = self.task_pool[math.random(#self.task_pool)]:new()
		table.insert(self.task_sequence, current_next_task)
	end
	self.current_task = self.task_sequence[self.task_index]
	self.current_task:setup()
end

function Round:teardown()
	print("Ending the round")
end

function Round:advance_task()
	self.task_index = self.task_index + 1
	self.current_task = self.task_sequence[self.task_index]

	self.current_task:setup()
	self.current_task:apply_config()
end

function Round:teardown_current_task()
	self.current_task:teardown()
end

function Round:task_completed()
	local result = self.current_task:completed()
	if result then
		table.insert(self.status_list, true)
	end
	return result
end
function Round:task_failed()
	local result = self.current_task:failed()
	if result then
		table.insert(self.status_list, false)
	end
	return result
end

function Round:completed()
	local index_diff = self.task_index - #self.task_sequence
	print(index_diff)
	return index_diff == 0
end

return Round
