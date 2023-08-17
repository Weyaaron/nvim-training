if vim.g.loaded_training == 1 then
	print("Already loaded")
	return
end
vim.g.loaded_training = 1

function construct_base_path()
	--https://stackoverflow.com/questions/6380820/get-containing-path-of-lua-file
	function script_path()
		local str = debug.getinfo(2, "S").source:sub(2)
		local initial_result = str:match("(.*/)")
		return initial_result
	end

	local base_path = script_path() .. "../"
	return base_path
end

local base_path = construct_base_path()
vim.api.nvim_command("set runtimepath^=" .. base_path)

--Todo: There should be a less convoluted way of copying a file, but this is sufficient for now
function copy_json()
	local utility = require("nvim_training.utility")
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
	local Task_sequence = require("nvim_training.task_sequence")
	copy_json()
	local Config = require("nvim_training.config")
	Config:load_from_json()

	local current_task_sequence = Task_sequence:new()
	current_task_sequence:switch_to_next_task()
end

vim.api.nvim_create_user_command("Training", setup, {})
