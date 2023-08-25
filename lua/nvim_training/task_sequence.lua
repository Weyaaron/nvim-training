-- luacheck: globals vim

local AbsoluteLineTask = require("lua.nvim_training.tasks.movements.absolute_line")
local RelativeLineTask = require("lua.nvim_training.tasks.movements.relative_line")
local SearchTask = require("lua.nvim_training.tasks.movements.search_task")
local MoveMark = require("lua.nvim_training.tasks.movements.move_mark")
local wTask = require("lua.nvim_training.tasks.movements.w_movement_task")
local eTask = require("lua.nvim_training.tasks.movements.e_movement_task")
local bTask = require("lua.nvim_training.tasks.movements.b_movement")
local DollarTask = require("lua.nvim_training.tasks.movements.dollar_movement")
local charTask = require("lua.nvim_training.tasks.movements.char_movement")
local StartOfLineTask = require("lua.nvim_training.tasks.movements.start_of_line_movement")
local utility = require("nvim_training.utility")

local audio_interface = require("nvim_training.audio_feedback"):new()
local total_task_pool = {
	charTask,
	AbsoluteLineTask,
	RelativeLineTask,
	wTask,
	eTask,
	SearchTask,
	MoveMark,
	bTask,
	DollarTask,
	StartOfLineTask,
}

local current_window = vim.api.nvim_tabpage_get_win(0)
local user_interface = require("lua.nvim_training.user_interface"):new()
vim.api.nvim_set_current_win(current_window)

local TaskSequence = {}
TaskSequence.__index = TaskSequence

function TaskSequence:new()
	local base = {
		task_length = 3,
		task_index = 0,
		status_list = {},
		task_sequence = {},
		task_pool = {},
		active_autocmds = {},
		current_level = 1,
		round_counter = 0,
		round_successfully = true,
	}
	setmetatable(base, { __index = self })
	base:_reset()
	return base
end

function TaskSequence:initialize_task_pool()
	--Todo: Deal with empty pool after filtering!
	if #vim.g.nvim_training.included_tags == 0 then
		self.task_pool = total_task_pool
	else
		for key, el in pairs(total_task_pool) do
			local allowed_intersection = utility.intersection(el.base_args.tags, vim.g.nvim_training.included_tags)
			if not (#allowed_intersection == 0) then
				table.insert(self.task_pool, el)
			end
		end
	end
	if not (#vim.g.nvim_training.excluded_tags == 0) then
		local new_pool = {}
		for key, el in pairs(self.task_pool) do
			local forbidden_intersection = utility.intersection(el.base_args.tags, vim.g.nvim_training.excluded_tags)
			if #forbidden_intersection == 0 then
				new_pool[key] = el
			end
		end
		self.task_pool = new_pool
	end
end

function TaskSequence:_reset()
	if self.round_successfully then
		self.round_counter = self.round_counter + 1
	end
	self.status_list = {}
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
	self.round_successfully = false

	self:_reset()
end

function TaskSequence:switch_to_next_task()
	for _, autocmd_el in pairs(self.active_autocmds) do
		vim.api.nvim_del_autocmd(autocmd_el)
	end
	self.active_autocmds = {}

	self.task_index = self.task_index + 1
	self.current_task = self.task_sequence[self.task_index]
	self.current_task:prepare()
	self.current_task:apply_config()

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
		self:_reset()
	end
	user_interface:display(self)
end

return TaskSequence
