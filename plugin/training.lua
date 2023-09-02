-- luacheck: globals vim

if vim.g.loaded_training == 1 then
	print("Already loaded")
	return
end
vim.g.loaded_training = 1

local function construct_base_path()
	--https://stackoverflow.com/questions/6380820/get-containing-path-of-lua-file
	local function script_path()
		local str = debug.getinfo(2, "S").source:sub(2)
		local initial_result = str:match("(.*/)")
		return initial_result
	end

	local base_path = script_path() .. "../"
	return base_path
end

--This is a construct I am not entirely happy with. There
--might be a better way.
local base_path = construct_base_path()
vim.api.nvim_command("set runtimepath^=" .. base_path)

local utility = require("nvim_training.utility")
local base_config_path = utility.construct_project_base_path("./plugin/default_config.json")
utility.load_config_file_into_global_namespace(base_config_path)

local function setup()
	local Task_sequence = require("nvim_training.task_sequence")
	local current_task_sequence = Task_sequence:new()
	current_task_sequence:setup()
end

vim.api.nvim_create_user_command("Training", setup, {})
