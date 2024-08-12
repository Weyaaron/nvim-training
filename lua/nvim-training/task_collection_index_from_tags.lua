local utility = require("nvim-training.utility")
local task_index = require("nvim-training.task_index")
local TaskCollection = require("nvim-training.task_collection")
local all_task_keys = utility.get_keys(task_index)
table.sort(all_task_keys)

local all_pieces = {}
for i, v in pairs(task_index) do
	local current_pieces = utility.split_str(v.__metadata.tags, ",")
	for ii, vv in pairs(current_pieces) do
		vv = utility.trim(vv)
		all_pieces[vv] = vv
	end
end
local index = {}
for name, v in pairs(all_pieces) do
	index[name] = TaskCollection:new(
		"All",
		"All supported tasks. Does involve tasks that are designed with plugins in mind!",
		utility.filter_tasks_by_tags(task_index, { name })
	)
end

return index
