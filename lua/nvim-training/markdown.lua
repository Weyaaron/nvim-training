local task_collection_index = require("nvim-training.task_collection_index")

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
print(result)
