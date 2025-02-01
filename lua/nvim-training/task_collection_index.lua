local TaskCollection = require("nvim-training.task_collection")
local utility = require("nvim-training.utility")
local task_index = require("nvim-training.task_index")
local user_config = require("nvim-training.user_config")

local all_task_keys = utility.get_keys(task_index)
table.sort(all_task_keys)

local full_tags_table = {}

for i, task_el in pairs(task_index) do
	full_tags_table[#full_tags_table + 1] = task_el.metadata.tags
end
full_tags_table = utility.flatten(full_tags_table)
full_tags_table = utility.remove_duplicates_from_iindex_based_table(full_tags_table)

local task_desc_index = {
	{ "All", "All currently supported tasks", all_task_keys },
	{ "Movement", "Tasks involving movements.", utility.create_task_list_with_given_tags({ "movement" }) },
	{ "Change", "Tasks involving some change to the buffer.", utility.create_task_list_with_given_tags({ "change" }) },
	{ "Yanking", "Tasks involving yanking", utility.create_task_list_with_given_tags({ "yank" }) },
	{ "f", "Tasks involving f", utility.create_task_list_with_given_tags({ "f" }) },
	{ "F", "Tasks involving F", utility.create_task_list_with_given_tags({ "F" }) },
	{ "t", "Tasks involving t", utility.create_task_list_with_given_tags({ "t" }) },
	{ "T", "Tasks involving T", utility.create_task_list_with_given_tags({ "T" }) },
	{ "Deletion", "Tasks involving deletion", utility.create_task_list_with_given_tags({ "deletion" }) },
	{ "Word", "Word-based Tasks", utility.create_task_list_with_given_tags({ "word" }) },
	{ "WORD", "WORD-based Tasks", utility.create_task_list_with_given_tags({ "WORD" }) },
	{ "Search", "Tasks involving search", utility.create_task_list_with_given_tags({ "search" }) },
}

local initial_index = {}

for i, task_collection_desc_el in pairs(task_desc_index) do
	initial_index[task_collection_desc_el[1]] = TaskCollection:new(task_collection_desc_el)
end

for name_key, name_table in pairs(user_config.custom_collections) do
	if initial_index[name_key] ~= nil then
		print("Your custom collection '" .. name_key .. "' is overwriting a buildin-collection.")
	end
	local tmp_desc = { name_key, "Custom Collection", name_table }
	initial_index[name_key] = TaskCollection:new(tmp_desc)
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
