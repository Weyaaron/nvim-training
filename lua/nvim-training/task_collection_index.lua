local TaskCollection = require("nvim-training.task_collection")
local utility = require("nvim-training.utility")
local task_index = require("nvim-training.task_index")

local all_task_keys = utility.get_keys(task_index)
table.sort(all_task_keys)

local movement_tasks = utility.filter_tasks_by_tags(task_index, { "movement" })
local change_tasks = utility.filter_tasks_by_tags(task_index, { "change" })
local non_movements = utility.discard_tasks_by_tags(task_index, { "movement" })
local yank = utility.filter_tasks_by_tags(task_index, { "yanking" })

local index = {
	All = TaskCollection:new("All", "All of the current tasks.", all_task_keys),
	Change = TaskCollection:new("Change", "All tasks involving some change to the buffer.", change_tasks),
	Movement = TaskCollection:new("Movements", "All tasks involving movement.", movement_tasks),
	NonMovement = TaskCollection:new("NonMovements", "All tasks not involving movement.", non_movements),
	Yanking = TaskCollection:new("Yanking", "All tasks involving yanking", yank),
}

return index
