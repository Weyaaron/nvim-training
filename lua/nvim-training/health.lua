local task_index = require("nvim-training.task_index")
local user_config = require("nvim-training.user_config")
local M = {}

local suffix = "Please check for spelling, and ensure you are using the right version of the plugin."

M.check = function()
	vim.health.start("Tasks")
	local task_list_empty = #user_config.task_list == 0
	vim.health.ok("Currently work in progress.")
	--
	-- if task_list_empty then
	-- 	vim.health.error(
	-- 		"You did not provide any tasks! Please run setup with a dictionary containing 'task_list' pointing to a list of strings that match names provided in the readme."
	-- 	)
	-- end
	--
	-- local all_tasks_resolved = not task_list_empty
	-- for i, v in pairs(user_config.task_list) do
	-- 	local resolved_mod = task_index[v:lower()]
	-- 	if not resolved_mod then
	-- 		all_tasks_resolved = false
	-- 		vim.health.error(
	-- 			"The setup function was called with the task name '" .. v .. "'. This task does not exist! " .. suffix
	-- 		)
	-- 	end
	-- end
	-- if all_tasks_resolved then
	-- 	vim.health.ok("All task-names have been resolved.")
	-- end
	--
	-- vim.health.start("Scheduler")
	-- if not user_config.resolved_task_scheduler then
	-- 	vim.health.error(
	-- 		"The setup function was called with the scheduler name '"
	-- 			.. user_config.task_scheduler
	-- 			.. "'. This scheduler does not exist! "
	-- 			.. suffix
	-- 	)
	-- else
	-- 	vim.health.ok("Scheduler has been resolved.")
	-- end
	--Todo: Readd health check of the scheduler after logic rework
end

return M
