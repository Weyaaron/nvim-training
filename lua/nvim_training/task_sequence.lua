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

local total_task_pool = {
	AbsoluteLineTask,
	RelativeLineTask,
}

local current_window = vim.api.nvim_tabpage_get_win(0)
local user_interface = require("lua.nvim_training.user_interface"):new()
vim.api.nvim_set_current_win(current_window)

local TaskSequence = {}
TaskSequence.__index = TaskSequence

function TaskSequence:new()
	local base = {}
	setmetatable(base, { __index = self })
	base.task_pool = {}
	base.active_autocmds = {}
	base.current_level = nil
	base.current_round = nil
	base.level_index = 1
	return base
end
local Level = require("lua.nvim_training.task_managment.level")
function TaskSequence:setup()
	self:construct_task_pool()

	self.current_level = Level:new(self.task_pool, self.level_index)
	self.current_level:setup()
	self:advance_to_next_task()
	user_interface:display(self)
end

function TaskSequence:construct_task_pool()
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

function TaskSequence:advance_to_next_task()
	for _, autocmd_el in pairs(self.active_autocmds) do
		vim.api.nvim_del_autocmd(autocmd_el)
	end

	self.active_autocmds = {}

	local function handle_wrapper()
		--Todo: Shall we do something with the args from autocmd?
		self:handle_autocmd()
	end

	for _, autocmd_el in pairs(self.current_level.current_round.current_task.autocmds) do
		local next_autocmd = vim.api.nvim_create_autocmd({ autocmd_el }, {
			callback = handle_wrapper,
		})

		table.insert(self.active_autocmds, next_autocmd)
	end
end

function TaskSequence:handle_autocmd()
	local completed = self.current_level:task_completed()
	local failed = self.current_level:task_failed()
	local check_for_level = false

	if completed and not failed then
		self.current_level:teardown_current_task()
		self.current_level:advance_task()
		check_for_level = true
	end
	if not completed and failed then
		self.current_level:teardown_current_task()
		self.current_level:advance_task()
		check_for_level = true
	end
	if check_for_level then
		local level_completed = self.current_level:completed()
		if level_completed then
			self.current_level:teardown()
			self.level_index = self.level_index + 1

			self.current_level = Level:new(self.task_pool, self.level_index)
			self.current_level:setup()
		end
	end

	user_interface:display(self)
end

return TaskSequence
