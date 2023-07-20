local AbsoluteLineTask = require("src.tasks.absolute_line_task")

local progress = require("src.progress")
local status = require("src.status")
local total_task_pool = { AbsoluteLineTask }

local current_task = nil
local task_index = 1

local task_sequence = {}
local current_level = 1

function task_sequence.init()
	if current_task then
		current_task:teardown()
	end

	task_index = 1

	local sequence_length = 5

	local current_task_pool = {}
	for i, v in pairs(total_task_pool) do
		local instance = v:new()
		if instance.minimal_level >= current_level then
			current_task_pool[i] = v
		end
	end
	current_task_sequence = {}
	for i = 1, sequence_length do
		current_task_sequence[i] = current_task_pool[math.random(#current_task_pool)]:new()
	end
	current_task = current_task_sequence[task_index]
end

function task_sequence.complete_current_task()
	task_index = task_index + 1
	current_task = current_task_sequence[task_index]
end

function task_sequence.current_task()
	return current_task
end

function task_sequence.print()
	local task_list_str = ""
	for i, v in pairs(current_task_sequence) do
		task_list_str = task_list_str .. "\n" .. tostring(v.abr)
	end
	return task_list_str
end

return task_sequence
