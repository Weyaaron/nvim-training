local BufferPermutationTask = {}

local utility = require("src.utility")
local Task = require("src.task")

local minimal_keys = { "initial_buffer", "new_buffer", "desc", "cursor_position" }

function BufferPermutationTask:new()
	local newObj = Task:new()
	self.__index = self
	setmetatable(newObj, self)
	newObj.autocmds = { "TextChanged" }

	newObj:load_from_json("./buffer_data/test.buffer")
	for _, v in pairs(minimal_keys) do
		if not newObj[v] then
			print("Missing key!")
		end
	end
	utility.replace_main_buffer_with_str(newObj.initial_buffer)

	return newObj
end

function BufferPermutationTask:failed()
	return false
end

function BufferPermutationTask:completed()
	local lines = vim.api.nvim_buf_line_count(0)
	local new_buffer_lines = vim.api.nvim_buf_get_lines(0, 0, lines, false)

	local target_str = utility.split_str(self.buffer_data["new_buffer"])

	local comparison = #target_str == #new_buffer_lines
	if comparison then
		for i, v in pairs(new_buffer_lines) do
			comparison = comparison and v == target_str[i]
		end
	end

	return comparison
end

function BufferPermutationTask:teardown() end

return BufferPermutationTask
