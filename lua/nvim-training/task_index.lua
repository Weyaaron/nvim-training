local MoveEndOfLine = require("nvim-training.tasks.move_end_of_line")
local MoveStartOfLine = require("nvim-training.tasks.move_start_of_line")
local MoveStartOfFile = require("nvim-training.tasks.move_start_of_file")
local MoveEndOfFile = require("nvim-training.tasks.move_end_of_file")

local exported_tasks = {
	MoveEndOfLine = MoveEndOfLine,
	MoveStartOfLine = MoveStartOfLine,
	MoveEndOfFile = MoveEndOfFile,
	MoveStartOfFile = MoveStartOfFile,
}

for i, v in pairs(exported_tasks) do
	exported_tasks[string.lower(i)] = exported_tasks[i]
end

return exported_tasks
