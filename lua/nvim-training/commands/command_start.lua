local header = require("nvim-training.header")
local user_config = require("nvim-training.user_config")
local audio = require("nvim-training.audio")
local parsing = require("nvim-training.utilities.parsing")
local internal_config = require("nvim-training.internal_config")
local logging = require("nvim-training.logging")

local module = {}

module.test_interface = { task_results = {}, task_data = nil }

local task_count = 0
local success_count = 0
local failure_count = 0
local current_autocmd = -1
local toogle_discard = false
local current_task
local current_streak = 0
local max_streak = 0
--We have to start this one true to avoid issues at startup.
local previous_task_result = true
local resoveld_scheduler
local reset_task_list = true
local session_id
local is_running = false
--This is a number keept to seed the random number generation,
--its value is not particularly importart. It will be increased between tasks.
local random_seed = 124134

local function loop(autocmd_callback_data)
	--This sleep helps with some feedback, if we continue instantly the user might not recognize their actions clearly.
	vim.loop.sleep(500)

	--Unfortunatly, this code is quite involved because some autocmds trigger unintended and
	--we have to take care of the special case that we start the loop without an actual task at the startup.
	--The interesting part happens at the end, where we pick a new task and do some setup for it.
	if autocmd_callback_data then
		if autocmd_callback_data then
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
		utility.append_to_table_path(
			target_data,
			user_config.event_storage_directory_path .. tostring(session_id) .. ".json"
		)

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

	module.test_interface.task_results[#module.test_interface.task_results + 1] = previous_task_result

	local utility = require("nvim-training.utility")
	--This line ensures that the highlights of previous tasks are discarded.
	local internal_config = require("nvim-training.internal_config")
	vim.api.nvim_buf_clear_namespace(0, internal_config.global_hl_namespace, 0, -1)

	local last_task_name = ""
	if current_task then
		last_task_name = current_task.name
	end

	if not previous_task_result and user_config.enable_repeat_on_failure then
		math.randomseed(random_seed)
	else
		current_task = resoveld_scheduler:next(current_task, previous_task_result):new()
		random_seed = random_seed + 1
	end
	vim.cmd("set filetype=" .. current_task.file_type)

	logging.log("Task changed from " .. last_task_name .. " to " .. current_task.name, {})

	module.test_interface.task_data = current_task:construct_interface_data()
	current_task:activate()
	module.test_interface.current_task = current_task
	local target_data = {
		timestamp = os.time(),
		session_id = session_id,
		event = "task_start",
		task_name = current_task.name,
	}
	utility.append_to_table_path(
		target_data,
		user_config.event_storage_directory_path .. tostring(session_id) .. ".json"
	)
	--The header may contain artifacts from previous tasks. To combat this, we reset it to known values.
	header.reset()

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

	current_autocmd = vim.api.nvim_create_autocmd({ current_task.metadata.autocmd }, { callback = loop })
	toogle_discard = true
end

function module.execute(args)
	local utility = require("nvim-training.utility")
	local init = require("nvim-training.init")
	is_running = true
	init.configure({})

	vim.api.nvim_win_set_buf(0, internal_config.buf_id)

	vim.api.nvim_buf_set_lines(internal_config.buf_id, 0, 25, false, {})
	header.store_key_value_in_header("#d", "No task yet.")
	header.construct_header()

	session_id = utility.uuid()
	local target_data = {
		timestamp = os.time(),
		session_id = session_id,
		event = "session_start",
	}
	utility.append_to_table_path(
		target_data,
		user_config.event_storage_directory_path .. tostring(session_id) .. ".json"
	)

	local scheduler_index = require("nvim-training.scheduler_index")
	local collection_index = require("nvim-training.task_collection_index")
	local scheduler_name = parsing.match_text_list_to_args(utility.get_keys(scheduler_index), args)[1]
	local scheduler = scheduler_index[scheduler_name]

	if not scheduler then
		print("You did not provide a scheduler, 'RandomScheduler' will be used.")
		scheduler = scheduler_index["RandomScheduler"]
	end

	local provided_collection_names = parsing.match_text_list_to_args(utility.get_keys(collection_index), args)
	local provided_collections = {}

	for i, name_el in pairs(provided_collection_names) do
		provided_collections[#provided_collections + 1] = collection_index[name_el]
	end

	if #provided_collections == 0 then
		print("You did not provide a list of task collections, the collection 'All' will be used.")
		provided_collections[#provided_collections + 1] = collection_index["All"]
	end

	for i, collection_el in pairs(provided_collections) do
		for ii, forbidden_collection_name_el in pairs(user_config.disabled_collections) do
			if collection_el.name == forbidden_collection_name_el then
				provided_collections[i] = nil
				break
			end
		end
	end
	for i, collection_el in pairs(provided_collections) do
		for ii, task_el in pairs(collection_el.tasks) do
			for iii, tag_el in pairs(task_el.metadata.tags) do
				for iiii, forbidden_tag_el in pairs(user_config.disabled_tags) do
					if forbidden_tag_el == tag_el then
						collection_el.tasks[ii] = nil
					end
				end
			end
		end
		if #collection_el.tasks == 0 then
			provided_collections[i] = nil
		end
	end
	if #provided_collections == 0 then
		print("No collections provided. The collection 'All' will be used as a fallback.")
		provided_collections[#provided_collections + 1] = collection_index["All"]
	end
	resoveld_scheduler = scheduler:new(provided_collections)

	loop()
end

function module.stop()
	if is_running then
		vim.api.nvim_del_autocmd(current_autocmd)

		print("Training session closed.")
	else
		print("No Training Session running .")
	end
	is_running = false
	local utility = require("nvim-training.utility")
	local target_data = {
		timestamp = os.time(),
		session_id = session_id,
		event = "session_end",
	}
	utility.append_to_table_path(
		target_data,
		user_config.event_storage_directory_path .. tostring(session_id) .. ".json"
	)
end

function module.complete(arg_lead)
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
	local matching_schedulers = parsing.complete_from_text_list(arg_lead, scheduler_keys)

	if #matching_schedulers == 0 then
		matching_schedulers = scheduler_keys
	end

	local matching_collections = parsing.complete_from_text_list(arg_lead, collection_keys)

	if #matching_collections == 0 then
		matching_collections = collection_keys
	end

	local matching_and_not_already_prodived_collections = {}

	for i, v in pairs(matching_collections) do
		-- The additional space fixes an issue where substrings of taskcollections  are found
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

return module
