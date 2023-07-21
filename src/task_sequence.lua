local AbsoluteLineTask = require("src.tasks.absolute_line")
local RelativLineTask = require("src.tasks.relative_line")
local JumpMarkTask = require("src.tasks.jump_mark")

local total_task_pool = { JumpMarkTask }

local TaskSequence = {}

function TaskSequence:new()
	local newObj = { task_index = 1, current_level = 1 }
	self.__index = self
	setmetatable(newObj, self)

	local sequence_length = 5

	local current_task_pool = {}
	for i, v in pairs(total_task_pool) do
		local instance = v:new()
		if instance.minimal_level >= newObj.current_level then
			current_task_pool[i] = v
		end
	end
	newObj.task_sequence = {}
	for i = 1, sequence_length do
		newObj.task_sequence[i] = current_task_pool[math.random(#current_task_pool)]:new()
	end

	newObj.current_task = newObj.task_sequence[newObj.task_index]

	return newObj
end

function TaskSequence:complete_current_task()
	self.current_task:teardown()
	self.task_index = self.task_index + 1
	self.current_task = self.task_sequence[self.task_index]
end

function TaskSequence:print()
	local task_list_str = ""
	for i, v in pairs(self.task_sequence) do
		task_list_str = task_list_str .. "\n" .. tostring(v.abr)
	end
	return task_list_str
end

return TaskSequence
