if vim.g.loaded_training == 1 then
	print("Already loaded")
	return
end
vim.g.loaded_training = 1

local utility = require("nvim-training.utility")

local scheduler_index = require("nvim-training.scheduler_index")
local collection_index = require("nvim-training.task_collection_index")
local header = require("nvim-training.header")
local user_config = require("nvim-training.user_config")
local audio = require("nvim-training.audio")
local task_count = 0
local success_count = 0
local failure_count = 0
local current_autocmd = -1
local toogle_discard = false
local current_task
local current_streak = 0
local max_streak = 0
local previous_task_result
local resoveld_scheduler
local reset_task_list = true

local function init()
	--Todo: Check if file exists
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
			if autocmd_callback_data["event"] == "TextYankPost" or autocmd_callback_data["event"] == "InsertLeave" then
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
		previous_task_result = current_task:deactivate(autocmd_callback_data)
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
	if reset_task_list and success_count == 0 and failure_count == 1 then
		reset_task_list = false
		success_count = 0
		failure_count = 0
	end

	local at_startup = success_count == 0 and failure_count == 0

	if previous_task_result == true and not at_startup then
		if user_config.audio_feedback then
			audio.audio_feedback_success()
		end
	end

	if previous_task_result == false and not at_startup then
		if user_config.audio_feedback then
			audio.audio_feedback_failure()
		end
	end

	vim.schedule_wrap(function()
		--This line is included to ensure that each task starts in the same file. A task may jump around and this ensures
		--coming back.
		vim.cmd("sil e training.txt")
	end)()

	--This line ensures that the highlights of previous tasks are discarded.
	utility.clear_all_our_highlights()
	current_task = resoveld_scheduler:next(current_task, previous_task_result):new()
	current_task:activate()

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
	header.store_key_value_in_header("_d_", current_task:instructions())
	vim.schedule_wrap(function()
		header.store_key_value_in_header("_d_", current_task:instructions())
		header.construct_header()
	end)()

	current_autocmd = vim.api.nvim_create_autocmd({ current_task:metadata().autocmd }, { callback = loop })
	toogle_discard = true
end

local function training_cmd(opts)
	local fargs = opts.fargs
	local scheduler = fargs[1]

	if not scheduler then
		print("You did not provide a scheduler, 'RandomScheduler' will be used.")
		scheduler = "RandomScheduler"
	end

	local provided_collections = {}
	for i = 2, #fargs, 1 do
		if fargs[i] then
			provided_collections[#provided_collections + 1] = collection_index[fargs[i]]
		end
	end
	if #provided_collections == 0 then
		print("You did not provide a list of task collections, the collection 'All' will be used.")
		provided_collections[#provided_collections + 1] = collection_index["All"]
	end

	resoveld_scheduler = scheduler_index[scheduler]:new(provided_collections)
	init()
	loop()
end
local function training_complete(arg_lead, cmd_line, _)
	local scheduler_keys = utility.get_keys(scheduler_index)
	local collection_keys = utility.get_keys(collection_index)

	local scheduler_in_cmd_line = false
	for i, v in pairs(scheduler_keys) do
		if cmd_line:find(v) then
			scheduler_in_cmd_line = true
		end
	end

	local matching_schedulers = {}
	for i, scheduler_name in pairs(scheduler_keys) do
		local sub_str = scheduler_name:sub(1, #arg_lead)
		if sub_str == arg_lead then
			matching_schedulers[#matching_schedulers + 1] = scheduler_name
		end
	end

	if #matching_schedulers == 0 then
		matching_schedulers = scheduler_keys
	end

	local matching_collections = {}
	for i, collection_name in pairs(collection_keys) do
		if collection_name:sub(1, #arg_lead) == arg_lead then
			matching_collections[#matching_collections + 1] = collection_name
		end
	end
	if #matching_collections == 0 then
		matching_collections = collection_keys
	end

	local matching_and_not_already_prodived_collections = {}

	for i, v in pairs(matching_collections) do
		--  The additional space fixes an issue where substrings of taskcollections  are found
		if not cmd_line:find(" " .. v .. " ") then
			matching_and_not_already_prodived_collections[#matching_and_not_already_prodived_collections + 1] = v
		end
	end
	if #matching_schedulers == 0 then
		matching_schedulers = scheduler_keys
	end

	if not scheduler_in_cmd_line then
		return matching_schedulers
	end
	return matching_and_not_already_prodived_collections
end

vim.api.nvim_create_user_command("Training", training_cmd, {
	complete = training_complete,
	nargs = "*",
})
