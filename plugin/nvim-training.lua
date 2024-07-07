if vim.g.loaded_training == 1 then
	print("Already loaded")
	return
end
vim.g.loaded_training = 1

local utility = require("nvim-training.utility")

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
	--This sleep helps with some feedback, if we continue instantly the user might not recognize their actions clearly.
	vim.loop.sleep(500)

	--Unfortunatly, this code is quite involved because some autocmds trigger unintended and
	--we have to take care of the special case that we start the loop without an actual task at the startup.
	--The interesting part happens at the end, where we pick a new task and do some setup for it.
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

	local at_startup = success_count == 0 and failure_count == 0

	if previous_task_result == true and not at_startup then
		if user_config.audio_feedback then
			user_config.audio_feedback_success()
		end
	end

	if previous_task_result == false and not at_startup then
		if user_config.audio_feedback then
			user_config.audio_feedback_failure()
		end
	end
	vim.schedule_wrap(function()
		--This line is included to ensure that each task starts in the same file. A task may jump around and this ensures
		--coming back.
		vim.cmd("sil e training.txt")
	end)()

	--This line ensures that the highlights of previous tasks are discarded.
	utility.clear_all_our_highlights()
	current_task = user_config.resolved_task_scheduler:next(current_task, previous_task_result):new()

	--This gives tasks some options to configure the header, for example with a prefix and a suffix to turn the header into a block comment in a programming language
	local additional_header_values = current_task:construct_optional_header_args()

	for i, v in pairs(additional_header_values) do
		header.store_key_value_in_header(i, v)
	end

	header.store_key_value_in_header("_s_", success_count)
	header.store_key_value_in_header("_f_", failure_count)
	header.store_key_value_in_header("_streak_", current_streak)
	header.store_key_value_in_header("_maxstreak_", max_streak)
	--The description might not be available after task setup right away. This ensures that the header uses the latest information provided by the task.
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
		print("Your provided config is not valid. Please use the setup function as described in the Readme.")
	end
end, {})
