-- luacheck: globals vim

local AbsoluteLineTask = require("lua.nvim_training.tasks.movements.absolute_line")
local RelativeLineTask = require("lua.nvim_training.tasks.movements.relative_line")
local SearchTask = require("lua.nvim_training.tasks.movements.search")
local MoveMarkTask = require("lua.nvim_training.tasks.movements.move_mark")
local wTask = require("lua.nvim_training.tasks.movements.w")
local eTask = require("lua.nvim_training.tasks.movements.e")
local bTask = require("lua.nvim_training.tasks.movements.b")
local DollarTask = require("lua.nvim_training.tasks.movements.dollar")
local charTask = require("lua.nvim_training.tasks.movements.char")
local StartOfLineTask = require("lua.nvim_training.tasks.movements.start_of_line")
local utility = require("nvim_training.utility")

local total_task_pool = {
	AbsoluteLineTask,
	RelativeLineTask,
	charTask,
	SearchTask,
	StartOfLineTask,
	DollarTask,
	bTask,
	wTask,
	eTask,
	MoveMarkTask,
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
		for i, v in pairs(total_task_pool) do
			table.insert(self.task_pool, v:new())
		end
	else
		for key, el in pairs(total_task_pool) do
			local allowed_intersection = utility.intersection(el.base_args.tags, vim.g.nvim_training.included_tags)
			if not (#allowed_intersection == 0) then
				table.insert(self.task_pool, el:new())
			end
		end
	end
	if not (#vim.g.nvim_training.excluded_tags == 0) then
		local new_pool = {}
		for key, el in pairs(self.task_pool) do
			local forbidden_intersection = utility.intersection(el.base_args.tags, vim.g.nvim_training.excluded_tags)
			if #forbidden_intersection == 0 then
				table.insert(new_pool, el:new())
			end
		end
		self.task_pool = new_pool
	end

	local function _sort(a,b)
		return a.min_level < b.min_level
	end
	table.sort(self.task_pool, _sort)

	for i, v in pairs(self.task_pool) do
		local str_from_tags = table.concat(v.tags, ", ")
		--print("-".. v.description .. " (" .. str_from_tags ..")")
	end

	local task_pool_after_level_adjustments = {}
	for i, v in pairs(self.task_pool) do
		local is_included = (v.min_level <= self.level_index) and (v.min_level > -1)
		if is_included then
			table.insert(task_pool_after_level_adjustments, v)
		end
	end
	--Todo: Deal with empty pool after filtering!
	self.task_pool = task_pool_after_level_adjustments
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
			self:construct_task_pool()
		end
	end

	user_interface:display(self)
end

return TaskSequence
