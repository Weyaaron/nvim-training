local buffer_permutation_task = { desc = nil }
local data = {}
local utility = require("src.utility")

local minimal_keys = { "initial_buffer", "new_buffer", "desc", "cursor_position" }

function buffer_permutation_task.init()
	local data_table_from_json = utility.read_buffer_source_file("./buffer-files/test.buffer")
	for i, v in pairs(minimal_keys) do
		if not data_table_from_json[v] then
			print("Missing key!")
		end
	end

	utility.replace_main_buffer_with_str(data_table_from_json["new_buffer"])

	buffer_permutation_task.desc = data_table_from_json["desc"]
end

function buffer_permutation_task.check() end

function buffer_permutation_task.teardown() end

return buffer_permutation_task
