-- luacheck: globals vim global_log

local AbsoluteLineTask = require("nvim_training.tasks.movements.absolute_line")
local RelativeLineTask = require("nvim_training.tasks.movements.relative_line")
local SearchTask = require("nvim_training.tasks.movements.search")
local MoveMarkTask = require("nvim_training.tasks.movements.move_mark")
local wTask = require("nvim_training.tasks.movements.w")
local eTask = require("nvim_training.tasks.movements.e")
local bTask = require("nvim_training.tasks.movements.b")
local DollarTask = require("nvim_training.tasks.movements.dollar")
local charTask = require("nvim_training.tasks.movements.char")
local StartOfLineTask = require("nvim_training.tasks.movements.start_of_line")
local QuestionMarkTask = require("nvim_training.tasks.movements.question_mark")
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
	QuestionMarkTask,
}

local current_window = vim.api.nvim_tabpage_get_win(0)
local user_interface = require("nvim_training.ui.status_ui"):new()
vim.api.nvim_set_current_win(current_window)
global_log = require("nvim_training.log")

local os = require("os")
local date_pieces = os.date("*t")
--This is just fine for current purposes, but might be adjusted later
local date_as_log_name = date_pieces["year"] .. "-" .. date_pieces["month"] .. "-" .. date_pieces["day"]

--Currently, dirs are not supported in this path ...
global_log.outfile = "./nvim_training " .. date_as_log_name .. ".log"
local function log_exit()
	global_log.info("Exited the current session.")
end
global_log.info("Started current session.")

vim.api.nvim_create_autocmd({ "ExitPre" }, {
	callback = log_exit,
})

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
	base.previous_levels = {}
	return base
end
local Level = require("nvim_training.task_managment.level")
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

	local function _sort(a, b)
		return a.min_level < b.min_level
	end
	table.sort(self.task_pool, _sort)

	for i, v in pairs(self.task_pool) do
		table.sort(v.tags)
		local str_from_tags = table.concat(v.tags, ", ")
		--print("- ".. v.description .. " (" .. str_from_tags ..")")
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
	user_interface:display(self)
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
	user_interface:display(self)
end

function TaskSequence:handle_autocmd()
	user_interface:display(self)
	local result = self.current_level:compute_task_result()

	if result:completed() then
		self.current_level:teardown_current_task()
		self.current_level:advance_task()
	end
	if result:failed() then
		self.current_level:teardown_current_task()
		self.current_level:advance_task()
	end

	if self.current_level:completed() then
		global_log.info("Level completed!")
		self.current_level:teardown()
		self.level_index = self.level_index + 1
		table.insert(self.previous_levels, self.current_level)

		self:construct_task_pool()
		self.current_level = Level:new(self.task_pool, self.level_index)
		self.current_level:setup()
	end

	user_interface:display(self)
end

return TaskSequence
