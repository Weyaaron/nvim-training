local user_config = require("nvim-training.user_config")

local scheduler_index = require("nvim-training.scheduler_index")
local startup = {}

function startup.resolve_task_list()
	local task_index = require("nvim-training.task_index")

	for i, v in pairs(user_config.task_list) do
		local resolved_mod = task_index[v]
		if not resolved_mod then
			print(
				"The setup function was called with the task name '"
					.. v
					.. "'. This task does not exist! Please use ':checkhealth' to check for errors. "
			)
		else
			user_config.resolved_task_list[#user_config.resolved_task_list + 1] = resolved_mod
		end
	end
end

function startup.construct_scheduler()
	local scheduler_name = user_config.task_scheduler
	if not scheduler_name then
		scheduler_name = "RandomScheduler"

		print("No scheduler with name " .. tostring(user_config.task_scheduler) .. "found, will use 'RandomScheduler'.")
	end
	user_config.resolved_task_scheduler =
		scheduler_index[scheduler_name:lower()]:new(user_config.resolved_task_list, user_config.task_scheduler_kwargs)
end

function startup.check_config()
	if #user_config.resolved_task_list == 0 then
		print(
			"You did not provide any tasks! Please run setup with a dictionary containing 'task_list' pointing to a list of strings that match names provided in the readme. You may use ':checkhealth' to validate your config."
		)

		return false
	end
	return true
end
function startup.construct_and_check_config()
	-- These two calls have to be in this order!
	startup.resolve_task_list()
	startup.construct_scheduler()
	return startup.check_config()
end

return startup
