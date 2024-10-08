local task_collection_index = require("nvim-training.task_collection_index")
local utility = require("nvim-training.utility")

local function generate_file_per_collection()
	local base_bath = utility.construct_base_path()
	local path = base_bath .. "/docs/collections/"
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

local module = {}

function module.execute(args, opts)
	generate_file_per_collection()
	generate_collection_list()
end

function module.stop() end

function module.complete(arg_lead) end

return module
