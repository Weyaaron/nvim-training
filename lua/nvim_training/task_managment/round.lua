-- luacheck: globals vim

local Round = {}
Round.__index = Round

local Result = require("nvim_training.task_result")
function Round:new(task_pool)
	local base = {}
	setmetatable(base, { __index = self })
	base.task_pool = task_pool
	base.round_length = vim.g.nvim_training.round_length + 1
	base.task_sequence = {}
	base.task_index = 0
	base.previous_tasks = {}
	base.result_container = {}
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

function Round:advance_task()
	table.insert(self.result_container, self.result)
	self.task_index = self.task_index + 1
	self.current_task = self.task_sequence[self.task_index]

	self.current_task:setup()
	self.current_task:apply_config()
end

function Round:teardown_current_task()
	self.current_task:teardown()
end

function Round:compute_task_result()
	local var_completed = self.current_task:completed()
	local var_failed = self.current_task:failed()
	self.result = Result:new(self.current_task, var_completed, var_failed)
	return self.result
end

function Round:completed()
	local index_diff = self.task_index - self.round_length
	return index_diff == 0
end

function Round:results()
	return self.result_container
end
function Round:teardown() end
return Round
