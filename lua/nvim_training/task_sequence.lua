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

local total_task_pool = { DeleteLineTask }

local included_tags = { "movement" }
local included_tags = { "ui" }
local excluded_tags = { "abc" }

local TaskSequence = {}
TaskSequence.__index = TaskSequence

function TaskSequence:new()
	--Task index starts at 0 to deal with first task initialisation
	local base = { task_length = 10, task_index = 1, status_list = {}, task_sequence = {} }
	setmetatable(base, { __index = self })
	base:_prepare()

	return base
end

function TaskSequence:_prepare()
	local current_task_pool = {}
	for key, el in pairs(total_task_pool) do
		local allowed_intersection = utility.intersection(el.base_args.tags, included_tags)
		local forbidden_intersection = utility.intersection(el.base_args.tags, excluded_tags)
		if #allowed_intersection > 0 and #forbidden_intersection == 0 then
			table.insert(current_task_pool, el)
		end
	end
	local current_task_pool = total_task_pool

	self.task_sequence = {}
	--Todo: Rework with next tasks in mind
	for i = 1, self.task_length do
		local current_next_task = current_task_pool[math.random(#current_task_pool)]:new()
		while current_next_task:first() do
			local attempt_to_find_next_task = current_next_task:first()
			if attempt_to_find_next_task then
				current_next_task = attempt_to_find_next_task:new()
			end
		end
		self.task_sequence[i] = current_next_task
		while current_next_task:next() do
			local next_task = current_next_task:next():new()
			i = i + 1
			self.task_sequence[i] = next_task
			current_next_task = next_task
		end
	end
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
	self.task_index = self.task_index + 1
	self.current_task = self.task_sequence[self.task_index]
	self.current_task:prepare()
end

return TaskSequence
