local AbsoluteLineTask = require("lua.nvim_training.tasks.movements.absolute_line")
local RelativeLineTask = require("lua.nvim_training.tasks.movements.relative_line")
local MoveMarkTask = require("lua.nvim_training.tasks.movements.move_mark")
local DeleteWordTask = require("lua.nvim_training.tasks.buffer_changes.delete_word")
local MoveWordForwardTask = require("lua.nvim_training.tasks.movements.word_forward_movement")
local TestTask = require("lua.nvim_training.tasks.test_task")
local RandomXYTask = require("lua.nvim_training.tasks.movements.random_line_char")
local FMovementTask = require("lua.nvim_training.tasks.movements.f_movement_task")
local TMovementTask = require("lua.nvim_training.tasks.movements.t_movement_task")
local eMovementTask = require("lua.nvim_training.tasks.movements.e_movement_task")
local SearchTask = require("lua.nvim_training.tasks.movements.search_task")
local utility = require("nvim_training.utility")

local audio_interface = require("nvim_training.audio_feedback"):new()
local Config = require("nvim_training.config")

local total_task_pool = { SearchTask}

local current_window = vim.api.nvim_tabpage_get_win(0)
local user_interface = require("lua.nvim_training.user_interface"):new()
vim.api.nvim_set_current_win(current_window)

local TaskSequence = {}
TaskSequence.__index = TaskSequence

function TaskSequence:new()
	local base =
		{ task_length = 10, task_index = 0, status_list = {}, task_sequence = {}, task_pool = {}, active_autocmds = {} }
	setmetatable(base, { __index = self })
	base:_prepare()
	return base
end

function TaskSequence:initialize_task_pool()
	--Todo: Deal with empty pool after filtering!
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
end

function TaskSequence:_prepare()
	self:initialize_task_pool()

	for i = 1, self.task_length do
		local current_next_task = self.task_pool[math.random(#self.task_pool)]:new()
		table.insert(self.task_sequence, current_next_task)
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
	for _, autocmd_el in pairs(self.active_autocmds) do
		vim.api.nvim_del_autocmd(autocmd_el)
	end
	self.active_autocmds = {}

	self.task_index = self.task_index + 1
	self.current_task = self.task_sequence[self.task_index]
	self.current_task:prepare()

	local function handle_wrapper()
		--Todo: Shall we do something with the args from autocmd?
		self:handle_autocmd()
	end

	for _, autocmd_el in pairs(self.current_task.autocmds) do
		local next_autocmd = vim.api.nvim_create_autocmd({ autocmd_el }, {
			callback = handle_wrapper,
		})

		table.insert(self.active_autocmds, next_autocmd)
	end
	user_interface:display(self)
end

function TaskSequence:handle_autocmd()
	local completed = self.current_task:completed()
	local failed = self.current_task:failed()
	if completed and not failed then
		self:complete_current_task()
		self:switch_to_next_task()
	end
	if failed and not completed then
		self:fail_current_task()
		self:switch_to_next_task()
	end
	if failed and completed then
		print("A Task should not both complete and fail!")
	end

	if self.task_length == self.task_index then
		--Todo: Ensure that this function works as intended!
		self:_prepare()
	end
	user_interface:display(self)
end

return TaskSequence
