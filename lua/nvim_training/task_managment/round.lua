-- luacheck: globals vim

local Round = {}
Round.__index = Round

local utility = require("lua.nvim_training.utility")
function Round:new(task_pool)
	local base = {
		task_length = 5,
		task_index = 1,
	}
	setmetatable(base, { __index = self })
	base.task_pool = task_pool
	return base
end

function Round:start()
	self.task_sequence = {}

	for i = 1, self.task_length do
		local current_next_task = self.task_pool[math.random(#self.task_pool)]:new()
		table.insert(self.task_sequence, current_next_task)
	end
	self.current_task = self.task_sequence[self.task_index]
	self.current_task:prepare()
end

function Round:end_()
	print("Ending the round")
end

function Round:advance_task()
	print("Advance called")
	print(self.current_task.desc)
	--Todo: Debug this?
	--self.current_task:tear_down()

	self.task_index = self.task_index + 1
	self.current_task = self.task_sequence[self.task_index]

	self.current_task:prepare()
	self.current_task:apply_config()
end

function Round:task_completed()
	return self.current_task:completed()
end
function Round:task_failed()
	return self.current_task:failed()
end

return Round
