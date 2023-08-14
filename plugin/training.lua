if vim.g.loaded_training == 1 then
	print("Not loaded")
	return
end
vim.g.loaded_training = 1

local Config = require("nvim_training.config")
local Task_sequence = require("nvim_training.task_sequence")
local utility = require("nvim_training.utility")

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
	Config:load_from_json()

	local current_task_sequence = Task_sequence:new()
	current_task_sequence:switch_to_next_task()
end

vim.api.nvim_create_user_command("Training", setup, {})

local training = {}
function training.config(args)
	for i, v in pairs(args) do
		Config[i] = v
	end
	Config:write_to_json()
	Config:load_from_json()
end

return training
