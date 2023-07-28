local AbsoluteLineTask = require("nvim_training.tasks.absolute_line")
local RelativeLineTask = require("nvim_training.tasks.relative_line")
local MoveMarkTask = require("nvim_training.tasks.move_mark")
local WordForwardMovementTask = require("nvim_training.tasks.word_forward_movement")
local DeleteWordTask = require("nvim_training.tasks.delete_word")
local DeleteLineTask = require("nvim_training.tasks.delete_line")
local OpenWindowTask = require("nvim_training.tasks.open_window")
local CloseWindowTask = require("nvim_training.tasks.close_window")

local utility = require("nvim_training.utility")
local audio_interface = require("nvim_training.audio_feedback"):new()
local Config = require("nvim_training.config")

local total_task_pool = { OpenWindowTask, CloseWindowTask }

local TaskSequence = {}
TaskSequence.__index = TaskSequence

function TaskSequence:new()
	local base = { task_length = 10, task_index = 1, status_list = {}, task_sequence = {}, task_pool = {} }
	setmetatable(base, { __index = self })
	base:_prepare()

	return base
end

function TaskSequence:initialize_task_pool()
	--Todo: Deal with empty poool after filtering!
	if #Config.included_tags == 0 then
		self.task_pool = total_task_pool
	else
		for key, el in pairs(total_task_pool) do
			local allowed_intersection = utility.intersection(el.base_args.tags, Config.included_tags)
			if not (#allowed_intersection == 0) then
				table.insert(self.task_pool, el)
			end
		end
	end
	if not (#Config.excluded_tags == 0) then
		local new_pool = {}
		for key, el in pairs(self.task_pool) do
			local forbidden_intersection = utility.intersection(el.base_args.tags, Config.excluded_tags)
			if #forbidden_intersection == 0 then
				new_pool[key] = el
			end
		end
		self.task_pool = new_pool
	end
	print("Pool length:" .. tostring(#self.task_pool))
end

function TaskSequence:_prepare()
	self:initialize_task_pool()

	for i = 1, self.task_length do
		local current_next_task = self.task_pool[math.random(#self.task_pool)]:new()
		local chain_for_current_task = current_next_task:calculate_task_chain()
		for chain_index, chained_task in pairs(chain_for_current_task) do
			table.insert(self.task_sequence, chained_task:new())
			i = i + 1
		end
	end
	self.task_length = #self.task_sequence
end

function TaskSequence:complete_current_task()
	table.insert(self.status_list, true)
	audio_interface:play_success_sound()
	self.current_task:teardown()
end

function TaskSequence:fail_current_task()
	table.insert(self.status_list, false)
	audio_interface:play_failure_sound()
	self.current_task:teardown()
end

function TaskSequence:switch_to_next_task()
	print("Switch in sequence called")
	self.task_index = self.task_index + 1
	self.current_task = self.task_sequence[self.task_index]
	self.current_task:prepare()
end

return TaskSequence
