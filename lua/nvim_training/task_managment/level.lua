-- luacheck: globals vim

local Level = {}
Level.__index = Level

function Level:new(task_pool, level)
	local base = {}
	setmetatable(base, { __index = self })
	base.round_index = 1
	base.level_length = vim.g.nvim_training.level_length
	base.task_pool = task_pool
	base.level = level

	return base
end
local Round = require("lua.nvim_training.task_managment.round")

function Level:setup()
	self.current_round = Round:new(self.task_pool)
	self.current_round:setup()
end

function Level:advance_round()


	local round_sucedet = true
	for i, v in pairs(self.current_round:results()) do
		round_sucedet = round_sucedet and v
	end
	if round_sucedet then
		self.round_index = self.round_index + 1
	end

	self.current_round:teardown()
	self.current_round = Round:new(self.task_pool)
	self.current_round:setup()
end

function Level:advance_task()
	self.current_round:advance_task()
end
function Level:task_completed()
	return self.current_round:task_completed()
end
function Level:task_failed()
	return self.current_round:task_failed()
end

function Level:completed()
	local round_completed = self.current_round:completed()
	if round_completed then
		self:advance_round()
	end

	if round_completed and self.round_index == self.max_rounds then
		return true
	end
	return false
end

function Level:teardown_current_task()
	self.current_round:teardown_current_task()
end
function Level:teardown()
	--Todo: Implement
end

return Level
