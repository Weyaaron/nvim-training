local MoveEndOfLine = require("nvim-training.tasks.move_end_of_line")
local MoveStartOfLine = require("nvim-training.tasks.move_start_of_line")
local MoveStartOfFile = require("nvim-training.tasks.move_start_of_file")
local MoveEndOfFile = require("nvim-training.tasks.move_end_of_file")
local SearchForward = require("nvim-training.tasks.search_forward")
local Increment = require("nvim-training.tasks.increment")
local PlaceMark = require("nvim-training.tasks.place_mark")

local MoveFunctions = require("nvim-training.tasks.move_functions")
local exported_tasks = {
	MoveEndOfLine = MoveEndOfLine,
	SearchForward = SearchForward,
	MoveStartOfLine = MoveStartOfLine,
	MoveEndOfFile = MoveEndOfFile,
	MoveStartOfFile = MoveStartOfFile,
	Increment = Increment,
	MoveFunctions = MoveFunctions,
	PlaceMark = PlaceMark,
}

for i, v in pairs(exported_tasks) do
	exported_tasks[string.lower(i)] = exported_tasks[i]
end

return exported_tasks
