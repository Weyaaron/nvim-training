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

local discard_movement = true

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
	print("Switch in main called")

	for _, autocmd_el in pairs(current_task_sequence.current_task.autocmds) do
		local next_autocmd = vim.api.nvim_create_autocmd({ autocmd_el }, {
			callback = outer_loop,
		})

		current_autocmds[#current_autocmds + 1] = next_autocmd
	end
	user_interface:display(current_task_sequence)
end

function loop()
	print("Loop Called")
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

	user_interface:display(current_task_sequence)
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

function setup()
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

--training.config({ enable_audio_feedback = false, excluded_tags = {"ui"} })
-- Fix problem with config that values linger around
training.config({ enable_audio_feedback = false, excluded_tags = {} })
