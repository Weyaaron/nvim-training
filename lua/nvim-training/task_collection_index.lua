local TaskCollection = require("nvim-training.task_collection")
local utility = require("nvim-training.utility")
local task_index = require("nvim-training.task_index")

local all_task_keys = utility.get_keys(task_index)
table.sort(all_task_keys)

local prefix = "Move"
--This is currently work in progress

local movement_tasks = {}
local non_movement_tasks = {}

for key, value in pairs(all_task_keys) do
	if value:sub(1, #prefix) == prefix then
		movement_tasks[#movement_tasks + 1] = value
	else
		non_movement_tasks[#non_movement_tasks + 1] = value
	end
end

local index = {
	All = TaskCollection:new("All", "All of the current tasks", all_task_keys),
	Movements = TaskCollection:new("All", "All tasks involving movements", movement_tasks),
	-- AllExludingMovements = TaskCollection:new("All", "All tasks involving movements", non_movement_tasks),
	-- Programming = TaskCollection:new("All", "All tasks involving programming", { "CommentLine", "CommentLineBlock" }),
	-- Testing = TaskCollection:new("All", "All tasks involving programming", { "MoveWord" }),
}

return index
