require("luarocks.loader")

local absolute_line_task = require("tasks/absolute_line_task")
local relative_line_task = require("tasks/relative_line_task")
local buffer_permutation_task = require("tasks/buffer_permutation")
local test_task = require("tasks.test_task")
local progress = require("progress")
local status = require("status")

local all_tasks = { absolute_line_task, relative_line_task, buffer_permutation_task }
all_tasks = { test_task }
local chosen_task = all_tasks[math.random(#all_tasks)]
local current_autocmds = {}

function main(autocmd_args)

	task_status = chosen_task.check()


	if chosen_task.check() then
		progress.update_streak()
	else
		progress.end_streak()
	end
	chosen_task.teardown()
	chosen_task = all_tasks[math.random(#all_tasks)]
	init_new_task()
end

function init_new_task()
	chosen_task.init()
	status.update(chosen_task.desc)

	for i, v in pairs(current_autocmds) do
		vim.api.nvim_del_autocmd(v)
	end
	current_autocmds = {}

	for i, v in pairs(chosen_task.autocmds) do
		current_autocmds[#current_autocmds + 1] = vim.api.nvim_create_autocmd({ v }, {
			callback = main,
		})
	end
end

local function setup()
	local current_window = vim.api.nvim_tabpage_get_win(0)

	progress.init()
	status.init()
	vim.api.nvim_set_current_win(current_window)
	init_new_task()
end

setup()
