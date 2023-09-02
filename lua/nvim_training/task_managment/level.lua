-- luacheck: globals vim

local Level = {}
Level.__index = Level

function Level:new(task_pool, level_index)
	local base = {}
	setmetatable(base, { __index = self })
	base.round_index = 1
	base.level_length = vim.g.nvim_training.level_length
	base.task_pool = task_pool
	base.level_index = level_index
	base.previous_rounds = {}

	return base
end
local Round = require("nvim_training.task_managment.round")

function Level:setup()
	self.current_round = Round:new(self.task_pool)
	self.current_round:setup()
end

function Level:advance_round()
	local round_completed_with_success = true
	for i, v in pairs(self.current_round:results()) do
		round_completed_with_success = round_completed_with_success and v:completed()
	end
	if round_completed_with_success then
		self.round_index = self.round_index + 1
	end

	self.current_round:teardown()
	table.insert(self.previous_rounds, self.current_round)
	self.current_round = Round:new(self.task_pool)
	self.current_round:setup()
end

function Level:advance_task()
	self.current_round:advance_task()
end
function Level:compute_task_result()
	return self.current_round:compute_task_result()
end

function Level:completed()
	local round_completed = self.current_round:completed()
	if round_completed then
		self:advance_round()
	end
	return round_completed and self.round_index == self.level_length
end

function Level:teardown_current_task()
	self.current_round:teardown_current_task()
end
function Level:teardown()
	--Todo: Implement
end

return Level
