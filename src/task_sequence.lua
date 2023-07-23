local AbsoluteLineTask = require("src.tasks.absolute_line")
local RelativeLineTask = require("src.tasks.relative_line")
local JumpMarkTask = require("src.tasks.jump_mark")
local WordJumpTask = require("src.tasks.word_jump")

local total_task_pool = { AbsoluteLineTask }

local TaskSequence = {}

function TaskSequence:new()
	--Task index starts at 0 to deal with first task initialisation
	local newObj = { task_index = 0, current_level = 1, status_list = {} }
	setmetatable(newObj, { __index = TaskSequence })

	local sequence_length = 15

	local current_task_pool = total_task_pool
	newObj.task_sequence = {}
	for i = 1, sequence_length do
		newObj.task_sequence[i] = current_task_pool[math.random(#current_task_pool)]:new()
	end

	return newObj
end

function TaskSequence:complete_current_task()
	self.status_list[#self.status_list + 1] = true

	if self.current_task then
		self.current_task:teardown()
	end
end

function TaskSequence:fail_current_task()
	self.status_list[#self.status_list + 1] = false
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
