-- luacheck: globals vim

local Level = {}
Level.__index = Level

local utility = require("lua.nvim_training.utility")
function Level:new(task_pool)
	local base = {
		length = 3,
		index = 0,
		status_list = {},
		tasks = {},
		task_pool = task_pool,
		active_autocmds = {},
	}
	setmetatable(base, { __index = self })
	return base
end
local Round = require("lua.nvim_training.task_managment.round")

function Level:start()
	self.current_round = Round:new(self.task_pool)
	self.current_round:start()
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
	--Todo: Implement!
	return false
end

function Level:end_() end

return Level
