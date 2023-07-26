if vim.g.loaded_training == 1 then
	print("Not loaded")
	return
end
vim.g.loaded_training = 1

require("luarocks.loader")

local UserInterFace = require("plugin.src.user_interface")
local current_autocmds = {}

local Task_sequence = require("plugin.src.task_sequence")
local current_task_sequence = Task_sequence:new()
local user_interface

local function switch_to_next_task()
	for _, autocmd_el in pairs(current_autocmds) do
		vim.api.nvim_del_autocmd(autocmd_el)
	end
	current_autocmds = {}

	current_task_sequence:switch_to_next_task()

	for _, autocmd_el in pairs(current_task_sequence.current_task.autocmds) do
		current_autocmds[#current_autocmds + 1] = vim.api.nvim_create_autocmd({ autocmd_el }, {
			callback = main,
		})
	end
	user_interface:display(current_task_sequence)
end

function main(autocmd_args)
	local completed = current_task_sequence.current_task:completed()
	local failed = current_task_sequence.current_task:failed()
	if completed and not failed then
		current_task_sequence:complete_current_task()
		switch_to_next_task()
	end
	if failed and not completed then
		current_task_sequence:fail_current_task()
		switch_to_next_task()
	end
	if failed and completed then
		print("A Task should not both complete and fail!")
	end

	user_interface:display(current_task_sequence)
end

function setup()
	local current_window = vim.api.nvim_tabpage_get_win(0)

	user_interface = UserInterFace:new()
	vim.api.nvim_set_current_win(current_window)
	switch_to_next_task()
end

vim.api.nvim_create_user_command("Training", setup, {})