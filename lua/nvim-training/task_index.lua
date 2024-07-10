local MoveEndOfLine = require("nvim-training.tasks.move_end_of_line")
local MoveStartOfLine = require("nvim-training.tasks.move_start_of_line")
local MoveStartOfFile = require("nvim-training.tasks.move_start_of_file")
local MoveEndOfFile = require("nvim-training.tasks.move_end_of_file")
local SearchForward = require("nvim-training.tasks.search_forward")

local Increment = require("nvim-training.tasks.increment")
local YankEndOfLine = require("nvim-training.tasks.yank_end_of_line")
local MoveYankWord = require("nvim-training.tasks.move_yank_word")
local CommentLine = require("nvim-training.tasks.comment_line")
local MoveRandomXY = require("nvim-training.tasks.move_random_x_y")

local exported_tasks = {
	MoveEndOfLine = MoveEndOfLine,
	SearchForward = SearchForward,
	MoveStartOfLine = MoveStartOfLine,
	MoveEndOfFile = MoveEndOfFile,
	MoveStartOfFile = MoveStartOfFile,
	Increment = Increment,
	YankEndOfLine = YankEndOfLine,
	YankWord = MoveYankWord,
	CommentLine = CommentLine,
	MoveRandomXY = MoveRandomXY,
}

for i, v in pairs(exported_tasks) do
	exported_tasks[string.lower(i)] = exported_tasks[i]
end

return exported_tasks
