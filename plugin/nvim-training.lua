local task_scheduler = require("nvim-training.task_scheduler")
if vim.g.loaded_training == 1 then
	print("Already loaded")
	return
end
vim.g.loaded_training = 1

local function construct_base_path()
	--https://stackoverflow.com/questions/6380820/get-containing-path-of-lua-file
	local function script_path()
		local str = debug.getinfo(1, "S").source:sub(2)
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

local header = require("nvim-training.header")
local user_config= require("nvim-training.user_config")

local task_count = 0
local success_count = 0
local failure_count = 0
local current_autocmd = -1
local toogle_discard = false
local current_task
local current_streak = 0
local max_streak = 0
local task_scheduler_instance
local previous_task_result
local function construct_and_check_config()
	local provided_tasks = user_config.task_list
	local length = 0
	if provided_tasks then
		length = #provided_tasks
	end
	if length == 0 then
		print(
			"You did not provide any tasks! Please run setup with a dictionary containing 'task_list' pointing to a list of strings that match names provided in the readme"
		)

		return false
	end

	--We load tasks this way to minimize startup
	local task_index = require("nvim-training.task_index")

	local resolved_modules = {}

	for i, v in pairs(user_config.task_list) do
		local resolved_mod = task_index[string.lower(v)]
		if not resolved_mod then
			print(
				"The setup function was called with the task name '"
					.. v
					.. "'. This task does not exist! Please check for spelling, and ensure you are using the right version of the plugin"
			)
			return false
		end
		resolved_modules[#resolved_modules + 1] = resolved_mod
	end
	user_config.task_list = resolved_modules

	local scheduler_index = require("nvim-training.scheduler_index")
	local scheduler_name = user_config.task_scheduler
	local resolved_scheduler = scheduler_index[string.lower(user_config.task_scheduler)]

	--Todo:  Split the config into the external and internal
	if not resolved_scheduler then
		print(
			"The setup function was called with the scheduler name '"
				.. user_config.task_scheduler
				.. "'. This scheduler does not exist! Please check for spelling/the right  plugin version."
		)
		return false
	end
	--Todo: Deal with kwargs
	task_scheduler_instance = resolved_scheduler:new(user_config.task_list, user_config.task_scheduler_kwargs)
	local expected_args = task_scheduler_instance:accepted_kwargs()

	for i, v in pairs(user_config.task_scheduler_kwargs) do
		if not expected_args[i] then
			print(
				"You provided the kwarg '"
					.. tostring(i)
					.. "' that is not understood by the scheduler '"
					.. scheduler_name
					.. "'. Please check for spelling or remove it."
			)
		end
	end
	for i, v in pairs(expected_args) do
		if not user_config.task_scheduler_kwargs[i] then
			print(
				"You did not provide a value for the scheduler kwarg named'"
					.. i
					.. "'. The default value '"
					.. tostring(v)
					.. "' will be used."
			)
		end
	end
	return true
end

local function init()
	vim.cmd("e training.txt")
	vim.api.nvim_buf_set_lines(0, 0, 25, false, {})
	vim.api.nvim_win_set_cursor(0, { 1, 1 })
	header.store_key_value_in_header("#d", "Es gibt noch keine Aufgabe")
	header.construct_header()
end

local function loop(autocmd_callback_data)
	vim.loop.sleep(500)
	if autocmd_callback_data then
		if autocmd_callback_data then
			--Todo: Extend after more event types are used.
			if autocmd_callback_data["event"] == "TextYankPost" then
				toogle_discard = false
			end
		end
		if toogle_discard then
			toogle_discard = false
			return
		end
		if current_autocmd > 0 then
			vim.api.nvim_del_autocmd(current_autocmd)
		end
		previous_task_result = current_task:teardown(autocmd_callback_data)
		task_count = task_count + 1
		if previous_task_result then
			success_count = success_count + 1
			current_streak = current_streak + 1
			if current_streak >= max_streak then
				max_streak = current_streak
			end
		else
			failure_count = failure_count + 1
			if current_streak >= max_streak then
				max_streak = current_streak
			end
			current_streak = 0
		end
	end

	current_task = task_scheduler_instance:next(current_task, previous_task_result):new()

	header.store_key_value_in_header("_s_", success_count)
	header.store_key_value_in_header("_f_", failure_count)
	header.store_key_value_in_header("_streak_", current_streak)
	header.store_key_value_in_header("_maxstreak_", max_streak)
	header.store_key_value_in_header("_d_", current_task:description())
	vim.schedule_wrap(function()
		header.construct_header()
	end)()
	current_autocmd = vim.api.nvim_create_autocmd({ current_task.autocmd }, { callback = loop })
	toogle_discard = true
end

vim.api.nvim_create_user_command("Training", function()
	if construct_and_check_config() then
		init()
		loop()
	else
		print("Your provided config is not valid. Please use the setup function as described in the readme")
	end
end, {})
