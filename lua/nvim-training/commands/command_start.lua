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
local session_id
local function init()
	--Todo: Check if file exists
	vim.cmd("e training.txt")
	vim.cmd("sil write!")
	vim.api.nvim_buf_set_lines(0, 0, 25, false, {})
	vim.cmd("sil write!")
	vim.api.nvim_win_set_cursor(0, { 1, 1 })
	header.store_key_value_in_header("#d", "Es gibt noch keine Aufgabe")
	header.construct_header()
end

local function loop(autocmd_callback_data)
	-- print("looped", vim.inspect(autocmd_callback_data))
	--This sleep helps with some feedback, if we continue instantly the user might not recognize their actions clearly.
	vim.loop.sleep(500)

	--Unfortunatly, this code is quite involved because some autocmds trigger unintended and
	--we have to take care of the special case that we start the loop without an actual task at the startup.
	--The interesting part happens at the end, where we pick a new task and do some setup for it.
	if autocmd_callback_data then
		if autocmd_callback_data then
			--Todo: Extend after more event types are used.
			if
				autocmd_callback_data["event"] == "TextYankPost"
				or autocmd_callback_data["event"] == "InsertLeave"
				or autocmd_callback_data["event"] == "WinNew"
			then
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

		local target_data = {
			result = previous_task_result,
			timestamp = os.time(),
			session_id = session_id,
			event = "task_end",
			task_name = current_task.name,
		}

		local utility = require("nvim-training.utility")
		-- utility.apppend_table_to_path(target_data, user_config.base_path .. tostring(session_id) .. ".json")

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
		vim.cmd("sil write!")
		vim.cmd("sil e training.txt")

		vim.cmd("sil write!")
	end)()

	local utility = require("nvim-training.utility")
	--This line ensures that the highlights of previous tasks are discarded.
	utility.clear_all_our_highlights()

	current_task = resoveld_scheduler:next(current_task, previous_task_result):new()
	current_task:activate()

	local target_data = {
		timestamp = os.time(),
		session_id = session_id,
		event = "task_start",
		task_name = current_task.name,
	}
	-- utility.apppend_table_to_path(target_data, user_config.base_path .. tostring(session_id) .. ".json")

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
local funcs = {}

--Todo: Rework the parsing, cant be bothered atm
function funcs.execute(args, opts)
	local utility = require("nvim-training.utility")
	session_id = utility.uuid()
	local target_data = {
		timestamp = os.time(),
		session_id = session_id,
		event = "session_start",
	}
	-- utility.apppend_table_to_path(target_data, user_config.base_path .. tostring(session_id) .. ".json")

	local scheduler_index = require("nvim-training.scheduler_index")
	local collection_index = require("nvim-training.task_collection_index")
	local fargs = opts.fargs
	local scheduler = scheduler_index[fargs[2]]

	if not scheduler then
		print("You did not provide a scheduler, 'RandomScheduler' will be used.")
		scheduler = scheduler_index["RandomScheduler"]
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

	resoveld_scheduler = scheduler:new(provided_collections)
	init()
	loop()
end

function funcs.stop()
	vim.api.nvim_del_autocmd(current_autocmd)
	local utility = require("nvim-training.utility")
	local target_data = {
		timestamp = os.time(),
		session_id = session_id,
		event = "session_end",
	}
	-- utility.apppend_table_to_path(target_data, user_config.base_path .. tostring(session_id) .. ".json")
	print("Session got closed.")
	--Todo: Delete stuff? Not quite sure
end

function funcs.complete(arg_lead)
	local scheduler_index = require("nvim-training.scheduler_index")

	local utility = require("nvim-training.utility")
	local collection_index = require("nvim-training.task_collection_index")
	local scheduler_keys = utility.get_keys(scheduler_index)
	local collection_keys = utility.get_keys(collection_index)

	local scheduler_in_cmd_line = false
	for i, v in pairs(scheduler_keys) do
		if arg_lead:find(v) then
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
		if not arg_lead:find(" " .. v .. " ") then
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

return funcs
