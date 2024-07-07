local user_config = require("nvim-training.user_config")
local startup = {}

function startup.construct_config()
	local task_index = require("nvim-training.task_index")

	for i, v in pairs(user_config.task_list) do
		local resolved_mod = task_index[v:lower()]
		if not resolved_mod then
			print(
				"The setup function was called with the task name '"
					.. v
					.. "'. This task does not exist! Please check for spelling, and ensure you are using the right version of the plugin."
			)
		end
		user_config.resolved_task_list[#user_config.resolved_task_list + 1] = resolved_mod
	end
end

function startup.check_scheduler()
	if not user_config.resolved_task_scheduler then
		print(
			"The setup function was called with the scheduler name '"
				.. user_config.task_scheduler
				.. "'. This scheduler does not exist! Please check for spelling/the right plugin version."
		)
		return false
	end
	local expected_args = user_config.resolved_task_scheduler:accepted_kwargs()

	for i, v in pairs(user_config.task_scheduler_kwargs) do
		if not expected_args[i] then
			print(
				"You provided the kwarg '"
					.. tostring(i)
					.. "' that is not understood by the scheduler '"
					.. user_config.task_scheduler
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
function startup.construct_scheduler()
	local new_scheduler_instance = nil
	local scheduler_index = require("nvim-training.scheduler_index")
	if scheduler_index[user_config.task_scheduler] then
		new_scheduler_instance = scheduler_index[user_config.task_scheduler:lower()]:new(
			user_config.resolved_task_list,
			user_config.task_scheduler_kwargs
		)
	else
		print("No scheduler with name " .. tostring(user_config.task_scheduler) .. "found")
	end
	user_config.resolved_task_scheduler = new_scheduler_instance
end

function startup.check_config()
	if #user_config.resolved_task_list == 0 then
		print(
			"You did not provide any tasks! Please run setup with a dictionary containing 'task_list' pointing to a list of strings that match names provided in the readme."
		)

		return false
	end
	return true
end
function startup.construct_and_check_config()
	-- These two calls have to be in this order!
	startup.construct_config()
	startup.construct_scheduler()
	return startup.check_config() and startup.check_scheduler()
end

return startup
