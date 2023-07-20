require("luarocks.loader")

local Progress = require("src.progress")
local Status = require("src.status")
local current_autocmds = {}

local current_level = 1
local level_requirements = { 10, 3 }
local Task_sequence = require("src.task_sequence")
local current_task_sequence = Task_sequence:new()
local status = nil
local progress = nil

function init_new_task()
	local task_list_str = current_task_sequence:print()
	status:update(current_task_sequence.current_task.desc .. "\n" .. task_list_str)

	for _, v in pairs(current_autocmds) do
		vim.api.nvim_del_autocmd(v)
	end
	current_autocmds = {}

	for _, v in pairs(current_task_sequence.current_task.autocmds) do
		current_autocmds[#current_autocmds + 1] = vim.api.nvim_create_autocmd({ v }, {
			callback = main,
		})
	end
end

function main(autocmd_args)
	local completed = current_task_sequence.current_task:completed()
	local failed = current_task_sequence.current_task:failed()
	if completed and not failed then
		progress:update_streak()
		current_task_sequence:complete_current_task()
		status:update(current_task_sequence.current_task.desc .. "\n")
	end
	if failed and not completed then
		progress:end_streak()
		current_task_sequence:complete_current_task()

		status:update(current_task_sequence.current_task.desc .. "\n")
	end
	if failed and completed then
		print("A Task should not both complete and fail!")
	end

	if completed and progress.progress_counter == level_requirements[current_level] then
		-- Todo: Readd levels
		print("Sucess")
	end
end

function setup()
	local current_window = vim.api.nvim_tabpage_get_win(0)

	progress = Progress:new()
	status = Status:new()
	vim.api.nvim_set_current_win(current_window)
	init_new_task()
end

setup()
