local TaskCollection = require("nvim-training.task_collection")
local utility = require("nvim-training.utility")
local task_index = require("nvim-training.task_index")
local user_config = require("nvim-training.user_config")

local all_task_keys = utility.get_keys(task_index)
table.sort(all_task_keys)

local movement_tasks = utility.filter_tasks_by_tags(task_index, { "movement" })
local change_tasks = utility.filter_tasks_by_tags(task_index, { "change" })
local non_movements = utility.discard_tasks_by_tags(task_index, { "movement" })
local yank = utility.filter_tasks_by_tags(task_index, { "yank" })

local index = {
	All = TaskCollection:new(
		"All",
		"All supported tasks. Does involve tasks that are designed with plugins in mind!",
		all_task_keys
	),
	Change = TaskCollection:new("Change", "Tasks involving some change to the buffer.", change_tasks),
	Movement = TaskCollection:new("Movements", "Tasks involving movement.", movement_tasks),
	NonMovement = TaskCollection:new("NonMovements", "Tasks not involving movement.", non_movements),
	Yanking = TaskCollection:new("Yanking", "Tasks involving yanking", yank),
}

return index
