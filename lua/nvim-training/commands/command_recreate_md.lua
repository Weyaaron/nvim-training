local task_collection_index = require("nvim-training.task_collection_index")
local utility = require("nvim-training.utility")

local function generate_file_per_collection()
	local base_bath = utility.construct_base_path()
	local path = base_bath .. "/docs/collections/"
	local table_header = "| Name | Description | Tags | Notes\n| --- | -------- | -------- | -------- |\n"
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
	local path = "./collection_list.md"

	local table_header = "| Name | Description | Link\n| ----------- | -------- | -------- |\n"
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

local function rebuild_readme()
	local readme_path = "./Readme.md"

	local file = io.open(readme_path, "r")
	local original_md_content = file:read("a")
	file:close()

	local table_header =
		"\n\n# All tasks\n\n| Name | Description | Tags | Notes\n| --- | -------- | -------- | -------- |\n"
	local all_block = task_collection_index.All:render_markdown()
	local start_index, start_end_index = string.find(original_md_content, "<!-- s -->", 1, true)
	local end_index, end_end_index = string.find(original_md_content, "<!-- e -->", 1, true)
	local prefix = original_md_content:sub(1, start_end_index)
	local suffix = original_md_content:sub(end_index, #original_md_content)

	print("Currently supported tasks: ", #task_collection_index.All.tasks)

	local new_md = prefix .. table_header .. all_block .. "\n" .. suffix
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
