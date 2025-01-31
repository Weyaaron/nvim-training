local TaskCollection = require("nvim-training.task_collection")
local utility = require("nvim-training.utility")
local task_index = require("nvim-training.task_index")
local user_config = require("nvim-training.user_config")

local all_task_keys = utility.get_keys(task_index)
table.sort(all_task_keys)

local full_tags_table = {}

for i, task_el in pairs(task_index) do
	full_tags_table[#full_tags_table + 1] = task_el.__metadata.tags
end
full_tags_table = utility.flatten(full_tags_table)
full_tags_table = utility.remove_duplicates_from_iindex_based_table(full_tags_table)
local initial_index = {
	All = TaskCollection:new(
		"All",
		"All supported tasks. Does involve tasks that are designed with plugins in mind!",
		full_tags_table
	),
	Change = TaskCollection:new("Change", "Tasks involving some change to the buffer.", { "change" }),
	Movement = TaskCollection:new("Movements", "Tasks involving movement.", { "movement" }),
	Yanking = TaskCollection:new("Yanking", "Tasks involving yanking", { "yank" }),
	f = TaskCollection:new("f", "Tasks involving f", { "f" }),
	F = TaskCollection:new("F", "Tasks involving F", { "F" }),
	t = TaskCollection:new("t", "Tasks involving t", { "t" }),
	T = TaskCollection:new("T", "Tasks involving T", { "T" }),
	Deletion = TaskCollection:new("Deletion", "Tasks involving deletion", { "deletion" }),
	Word = TaskCollection:new("Word", "Word-based Tasks", { "word" }),
	WORD = TaskCollection:new("WORD", "WORD-base Tasks", { "WORD" }),
	Movements = TaskCollection:new("Movements", "Tasks using cursor-movement", { "movement" }),
	Search = TaskCollection:new("Search", "Tasks using search", { "search" }),
}

for name_key, name_table in pairs(user_config.custom_collections) do
	if initial_index[name_key] ~= nil then
		print("Your custom collection '" .. name_key .. "' is overwriting a buildin-collection.")
	end
	initial_index[name_key] = TaskCollection:new(name_key, "Custom Collection", name_table)
end

local index_with_sufficient_length = {}

for name, task_collection_el in pairs(initial_index) do
	if #task_collection_el.tasks == 0 then
		print(
			"The task collection '" .. name .. "' does not contain any tasks! Please check for spelling/open a issue."
		)
	else
		index_with_sufficient_length[name] = task_collection_el
	end
end

return index_with_sufficient_length
