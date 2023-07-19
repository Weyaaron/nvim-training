require("luarocks.loader")

local absolute_line_task = require("src.tasks.absolute_line_task")
local relative_line_task = require("src.tasks.relative_line_task")
local progress = require("src.progress")
local status = require("src.status")

local current_task_pool = { absolute_line_task }
local chosen_task = current_task_pool[math.random(#current_task_pool)]
local current_autocmds = {}
local total_task_pool = { absolute_line_task, relative_line_task }

local current_level = 1
local level_requirements = { 10, 3 }

function init_new_task()
	chosen_task.teardown()
	chosen_task = current_task_pool[math.random(#current_task_pool)]

	chosen_task.init()
	status.update(chosen_task.desc)

	for _, v in pairs(current_autocmds) do
		vim.api.nvim_del_autocmd(v)
	end
	current_autocmds = {}

	for _, v in pairs(chosen_task.autocmds) do
		current_autocmds[#current_autocmds + 1] = vim.api.nvim_create_autocmd({ v }, {
			callback = main,
		})
	end
end

function main(autocmd_args)
	local completed = chosen_task.completed()
	local failed = chosen_task.failed()
	if completed and not failed then
		progress.update_streak()
		init_new_task()
	end
	if failed and not completed then
		progress.end_streak()
		init_new_task()
	end
	if failed and completed then
		print("A Task should not both complete and fail!")
	end

	if completed and progress.progress_counter == level_requirements[current_level] then
		level_up()
	end
end

function level_up()
	current_level = current_level + 1

	current_task_pool = {}
	for i, v in pairs(total_task_pool) do
		if v.minimal_level >= current_level then
			current_task_pool[i] = v
		end
	end
	progress.progress_counter = 0
end

function setup()
	local current_window = vim.api.nvim_tabpage_get_win(0)

	progress.init()
	status.init()
	vim.api.nvim_set_current_win(current_window)
	init_new_task()
end

setup()
