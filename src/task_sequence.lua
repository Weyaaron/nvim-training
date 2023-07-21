local AbsoluteLineTask = require("src.tasks.absolute_line")
local RelativLineTask = require("src.tasks.relative_line")
local JumpMarkTask = require("src.tasks.jump_mark")

local total_task_pool = { JumpMarkTask }

local TaskSequence = {}

function TaskSequence:new()
	--Task index starts at 0 to deal with first task initialisation
	local newObj = { task_index = 0, current_level = 1 }
	self.__index = self
	setmetatable(newObj, self)

	local sequence_length = 15

	local current_task_pool = {}
	for i, task_el in pairs(total_task_pool) do
		local instance = task_el:new()
		if instance.minimal_level >= newObj.current_level then
			current_task_pool[i] = task_el
		end
	end
	newObj.task_sequence = {}
	for i = 1, sequence_length do
		newObj.task_sequence[i] = current_task_pool[math.random(#current_task_pool)]:new()
	end

	return newObj
end

function TaskSequence:complete_current_task()
	if self.current_task then
		self.current_task:teardown()
	end
end

function TaskSequence:switch_to_next_task()
	self.task_index = self.task_index + 1
	self.current_task = self.task_sequence[self.task_index]
	self.current_task:prepare()
end

function TaskSequence:print()
	local task_list_str = ""
	for _, task_el in pairs(self.task_sequence) do
		task_list_str = task_list_str .. "\n" .. tostring(task_el.abr)
	end
	return task_list_str
end

return TaskSequence
