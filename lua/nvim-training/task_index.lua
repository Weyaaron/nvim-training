local MoveEndOfLine = require("nvim-training.tasks.move_end_of_line")
local MoveStartOfLine = require("nvim-training.tasks.move_start_of_line")
local MoveStartOfFile = require("nvim-training.tasks.move_start_of_file")
local MoveEndOfFile = require("nvim-training.tasks.move_end_of_file")
local SearchForward = require("nvim-training.tasks.search_forward")
local Increment = require("nvim-training.tasks.increment")
local YankEndOfLine = require("nvim-training.tasks.yank_end_of_line")
local YankIntoRegister = require("nvim-training.tasks.yank_into_register")
local YankWord = require("nvim-training.tasks.yank_word")

local exported_tasks = {
	MoveEndOfLine = MoveEndOfLine,
	SearchForward = SearchForward,
	MoveStartOfLine = MoveStartOfLine,
	MoveEndOfFile = MoveEndOfFile,
	MoveStartOfFile = MoveStartOfFile,
	Increment = Increment,
	YankEndOfLine = YankEndOfLine,
	YankIntoRegister = YankIntoRegister,
	YankWord = YankWord,
}

for i, v in pairs(exported_tasks) do
	exported_tasks[string.lower(i)] = exported_tasks[i]
end

return exported_tasks
