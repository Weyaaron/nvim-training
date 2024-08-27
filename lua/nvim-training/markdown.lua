local task_collection_index = require("nvim-training.task_collection_index")

local function generate_full_task_list()
	local path = "./output.md"

	local table_header = "| Name | Description | Tags | Notes \n| --- | -------- | -------- | -------- |"
	local collection_blocks = {}
	for i, v in pairs(task_collection_index) do
		local new_line = v:render_markdown(table_header)
		collection_blocks[#collection_blocks + 1] = new_line
	end
	table.sort(collection_blocks)

	local result = table.concat(collection_blocks, "\n\n")
	local file = io.open(path, "w")
	file:write(result)
	file:close()
end

generate_full_task_list()

local function generate_file_per_collection()
	local path = "/home/aaron/Code/Lua/nvim-training/docs/collections/"
	local table_header = "| Name | Description | Tags | Notes \n| --- | -------- | -------- | -------- |"
	for i, v in pairs(task_collection_index) do
		local current_block = v:render_markdown(table_header)
		local f_p = path .. v.name .. ".md"
		local file = io.open(f_p, "w")
		file:write(current_block)
		file:close()
	end
end

generate_file_per_collection()
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

generate_collection_list()
