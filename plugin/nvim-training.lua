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
local user_config = require("nvim-training.user_config")
local startup = require("nvim-training.startup")

local task_count = 0
local success_count = 0
local failure_count = 0
local current_autocmd = -1
local toogle_discard = false
local current_task
local current_streak = 0
local max_streak = 0
local previous_task_result

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

	current_task = user_config.resolved_task_scheduler:next(current_task, previous_task_result):new()

	header.store_key_value_in_header("_s_", success_count)
	header.store_key_value_in_header("_f_", failure_count)
	header.store_key_value_in_header("_streak_", current_streak)
	header.store_key_value_in_header("_maxstreak_", max_streak)

	header.store_key_value_in_header("_d_", current_task:description())
	vim.schedule_wrap(function()
		header.store_key_value_in_header("_d_", current_task:description())
		header.construct_header()
	end)()
	current_autocmd = vim.api.nvim_create_autocmd({ current_task.autocmd }, { callback = loop })
	toogle_discard = true
end

vim.api.nvim_create_user_command("Training", function()
	if startup.construct_and_check_config() then
		init()
		loop()
	else
		print("Your provided config is not valid. Please use the setup function as described in the readme.")
	end
end, {})
