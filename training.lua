require("luarocks.loader")

local absolute_line_task = require("tasks/absolute_line_task")
local relative_line_task = require("tasks/relative_line_task")
local buffer_permutation_task = require("tasks.buffer_permutation")
local progress = require("progress")
local status = require("status")

local all_tasks = { absolute_line_task, relative_line_task }
local all_tasks = { buffer_permutation_task }
local chosen_task = all_tasks[math.random(#all_tasks)]

local function main(autocmd_args)
	if chosen_task.check() then
		progress.update_streak()
	else
		progress.end_streak()
	end
	chosen_task.teardown()
	chosen_task = all_tasks[math.random(#all_tasks)]

	chosen_task.init()
	status.update(chosen_task.desc)
end

local function setup()
	local current_window = vim.api.nvim_tabpage_get_win(0)

	progress.init()
	status.init()
	vim.api.nvim_set_current_win(current_window)

	chosen_task.init()
	status.update(chosen_task.desc)

	--vim.api.nvim_create_autocmd({"CursorMoved"}, {
	--	callback = main,
	--})
end

setup()
