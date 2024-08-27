local task_collection_index = require("nvim-training.task_collection_index")
local utility = require("nvim-training.utility")
local task_index = require("nvim-training.task_index")
local scheduler_index = require("nvim-training.scheduler_index")

local function generate_full_task_list()
	local md_file = utility.construct_base_path() .. "/Readme.md"

	local file = io.open(md_file, "r")
	local current_readme_content = file:read("a")
	file:close()

	local table_header = "| Name | Description | Tags | Notes \n| --- | -------- | -------- | -------- |"
	local collection_blocks = {}
	for i, v in pairs(task_collection_index) do
		local new_line = v:render_markdown(table_header)
		collection_blocks[#collection_blocks + 1] = new_line
	end
	table.sort(collection_blocks)

	local result = table.concat(collection_blocks, "\n\n")

	local current_readme_blocks = utility.split_str(current_readme_content, "\n\n")
	local new_blocks = {}

	for i, v in pairs(current_readme_blocks) do
		local start_of_block = v:sub(0, 10)
		if start_of_block == table_header:sub(0, 10) then
			current_readme_blocks[i] = result
		end
	end

	local full_file_result = table.concat(new_blocks, "\n\n")

	local file = io.open(md_file, "w")
	file:write(full_file_result)
	file:close()
end

local function generate_file_per_collection()
	local base_bath = utility.construct_base_path()
	local path = base_bath .. "docs/collections/"
	local table_header = "| Name | Description | Tags | Notes \n| --- | -------- | -------- | -------- |"
	for i, v in pairs(task_collection_index) do
		local current_block = v:render_markdown(table_header)
		local f_p = path .. v.name .. ".md"
		local file = io.open(f_p, "w")
		file:write(current_block)
		file:close()
	end
end

local function generate_collection_list()
	local path = "./collection_list.md"

	local table_header = "| Name | Description | Link \n| ----------- | -------- | -------- |"
	local collection_blocks = {}
	for i, v in pairs(task_collection_index) do
		collection_blocks[#collection_blocks + 1] = "| "
			.. v.name
			.. " | "
			.. v.desc
			.. "| ["
			.. v.name
			.. "](/docs/collections/"
			.. v.name
			.. ".md)"
	end
	table.sort(collection_blocks)

	local result = table.concat(collection_blocks, "\n")
	local file = io.open(path, "w")
	file:write(table_header .. "\n")
	file:write(result)
	file:close()
end

local function generate_stats()
	local path = "./stats.md"
	local result = ""
	result = result .. "- Currently supported tasks: " .. tostring(#utility.get_keys(task_index)) .. "\n"
	result = result
		.. "- Currently supported task collections: "
		.. tostring(#utility.get_keys(task_collection_index))
		.. "\n"
	result = result .. "- Currently supported task schedulers: " .. tostring(#utility.get_keys(scheduler_index)) .. "\n"
	--Not a particularly good idea
	-- local all_tags = utility.gather_tags(task_index)
	--
	-- local tag_list = utility.get_keys(all_tags)
	-- table.sort(tag_list)
	-- local all_tags_joined = table.concat(tag_list, ",")
	-- result = result .. "- Currently supported task tags: " .. all_tags_joined .. "\n"
	--

	-- local file = io.open(path, "w")
	-- file:write(result)
	-- file:close()
	-- print(result)
end

local module = {}

function module.execute(args, opts)
	-- generate_full_task_list()
	-- generate_file_per_collection()
	-- generate_collection_list()
	generate_stats()
end

function module.stop() end

function module.complete(arg_lead) end

return module
