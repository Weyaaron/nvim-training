require("luarocks.loader")

local absolute_line_task = require("src.tasks.absolute_line_task")
local relative_line_task = require("src.tasks.relative_line_task")
local progress = require("src.progress")
local status = require("src.status")

local all_tasks = { absolute_line_task, relative_line_task }
local chosen_task = all_tasks[math.random(#all_tasks)]
local current_autocmds = {}

function main(autocmd_args)
	completed = chosen_task.completed()
	failed = chosen_task.failed()
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
end

function init_new_task()
	chosen_task.teardown()
	chosen_task = all_tasks[math.random(#all_tasks)]

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
