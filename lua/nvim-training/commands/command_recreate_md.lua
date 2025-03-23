local task_collection_index = require("nvim-training.task_collection_index")
local utility = require("nvim-training.utility")

local function generate_file_per_collection()
	local base_bath = utility.construct_base_path()
	local path = base_bath .. "/docs/collections/"
	local table_header = "| Name | Description | Tags\n| --- | -------- | -------- |\n"
	for i, v in pairs(task_collection_index) do
		local current_block = v:render_markdown(table_header)
		local constructed_header = "## " .. v.name .. " (" .. v.desc .. ")\n" .. table_header

		local current_block_with_header = constructed_header .. current_block
		local f_p = path .. v.name .. ".md"
		local file = io.open(f_p, "w")
		file:write(current_block_with_header)
		file:close()
	end
end

local function generate_collection_list()
	local table_header = "| Name | Description | Details\n| ----------- | -------- | -------- |\n"
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
	return "\n" .. table_header .. result .. "\n"
end
local function generate_task_list()
	local table_header = "\n\n# All tasks\n\n| Name | Description | Tags\n| --- | -------- | -------- | \n"
	local all_block = task_collection_index.All:render_markdown()
	return "\n" .. table_header .. all_block .. "\n"
end

local function rebuild_readme()
	local readme_path = "./Readme.md"

	local file = io.open(readme_path, "r")
	local original_md_content = file:read("a")
	file:close()

	local task_list = generate_task_list()
	local new_md = utility.replace_content_in_md(original_md_content, task_list, 1)
	local collection_list = generate_collection_list()
	new_md = utility.replace_content_in_md(new_md, collection_list, 2)

	local file = io.open(readme_path, "w")
	file:write(new_md)
	file:close()
end

local module = {}

function module.execute(args, opts)
	generate_file_per_collection()
	generate_collection_list()
	rebuild_readme()
end

function module.stop() end

function module.complete(arg_lead) end

return module
