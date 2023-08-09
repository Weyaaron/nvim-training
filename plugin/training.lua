if vim.g.loaded_training == 1 then
	print("Not loaded")
	return
end
vim.g.loaded_training = 1

local function attempt_input()
	local UserInterFace = require("nvim_training.user_interface")
end
local imports_succesfull = pcall(attempt_input)
if not imports_succesfull then
	--Fixes runtimepath for local development
	vim.cmd(":set runtimepath=/home/aaron/Code/Lua/nvim_training")
	vim.api.nvim_command("set runtimepath^=/home/aaron/Code/Lua/nvim_training")
	vim.cmd(":ASToggle")
end

local Config = require("nvim_training.config")
local UserInterFace = require("nvim_training.user_interface")
local current_autocmds = {}

local Task_sequence = require("nvim_training.task_sequence")
local current_task_sequence = Task_sequence:new()
local user_interface
local utility = require("nvim_training.utility")

local discard_movement = true
-- This is a crude solution to the fact that the cursor moves after entering :Training.
-- This messes up movement based tasks. Any suggestions for a improvement are appreciated.
function outer_loop()
	if not discard_movement then
		loop()
	end
	discard_movement = false
end

local function switch_to_next_task()
	for _, autocmd_el in pairs(current_autocmds) do
		vim.api.nvim_del_autocmd(autocmd_el)
	end
	current_autocmds = {}

	current_task_sequence:switch_to_next_task()

	for _, autocmd_el in pairs(current_task_sequence.current_task.autocmds) do
		local next_autocmd = vim.api.nvim_create_autocmd({ autocmd_el }, {
			callback = outer_loop,
		})

		current_autocmds[#current_autocmds + 1] = next_autocmd
	end
	user_interface:display(current_task_sequence)
end

function loop()
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

	if current_task_sequence.task_length == current_task_sequence.task_index then
		current_task_sequence = Task_sequence:new()
		setup_first_task()
	end

end

function setup_first_task()
	current_task_sequence.current_task = current_task_sequence.task_sequence[1]
	current_task_sequence.current_task:prepare()

	for _, autocmd_el in pairs(current_task_sequence.current_task.autocmds) do
		current_autocmds[#current_autocmds + 1] = vim.api.nvim_create_autocmd({ autocmd_el }, {
			callback = outer_loop,
		})
	end
end

--Todo: There should be a less convoluted way of copying a file, but this is sufficient for now
function copy_json()
	local base_config_path = utility.construct_project_base_path("./plugin/default_config.json")
	local source_file = io.open(base_config_path)
	local content = source_file:read("a")
	source_file:close()

	local target_config_path = utility.construct_project_base_path("current_config.json")
	local target_file = io.open(target_config_path, "w")

	target_file:write(content)
	target_file:close()
end

function setup()
	copy_json()

	local current_window = vim.api.nvim_tabpage_get_win(0)

	user_interface = UserInterFace:new()
	vim.api.nvim_set_current_win(current_window)
	setup_first_task()

	user_interface:display(current_task_sequence)

	Config:load_from_json()
end

vim.api.nvim_create_user_command("Training", setup, {})
if not imports_sucesfull then
	vim.cmd(":Training")
end

local training = {}
function training.config(args)
	for i, v in pairs(args) do
		Config[i] = v
	end
	Config:write_to_json()
	Config:load_from_json()
end

return training
