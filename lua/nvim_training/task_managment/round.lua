-- luacheck: globals vim

local Round = {}
Round.__index = Round

function Round:new(task_pool)
	local base = {}
	setmetatable(base, { __index = self })
	base.task_pool = task_pool
	base.round_length = vim.g.nvim_training.round_length + 1
	self.task_sequence = {}
	self.task_index = 0
	return base
end

function Round:setup()
	self.task_sequence = {}

	for _ = 1, self.round_length do
		local current_next_task = self.task_pool[math.random(#self.task_pool)]
		table.insert(self.task_sequence, current_next_task)
	end
	self:advance_task()
end

function Round:teardown() end

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
		self.current_task.result = true
	end
	return result
end
function Round:task_failed()
	local result = self.current_task:failed()
	if result then
		self.current_task.result = false
	end
	return result
end

function Round:completed()
	local index_diff = self.task_index - self.round_length
	return index_diff == 0
end

function Round:results()
	local results = {}
	for i = 1, self.task_index do
		table.insert(results, self.task_sequence[i].result)
	end
	return results
end

return Round