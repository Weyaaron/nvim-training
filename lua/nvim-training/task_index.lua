local MoveEndOfLine = require("nvim-training.tasks.move_end_of_line")
local MoveStartOfLine = require("nvim-training.tasks.move_start_of_line")
local MoveStartOfFile = require("nvim-training.tasks.move_start_of_file")
local MoveEndOfFile = require("nvim-training.tasks.move_end_of_file")
local SearchForward = require("nvim-training.tasks.search_forward")
local Increment = require("nvim-training.tasks.increment")
local CommentLine = require("nvim-training.tasks.comment_line")
local CommentLineBlock = require("nvim-training.tasks.comment_line_block")
local MoveRandomXY = require("nvim-training.tasks.move_random_x_y")
local DeleteInsideMatch = require("nvim-training.tasks.delete_inside_match")
local YankInsideMatch = require("nvim-training.tasks.yank_inside_match")
local MoveMatch = require("nvim-training.tasks.move_match")
local MoveWord = require("nvim-training.tasks.move_word")
local MoveWordEnd = require("nvim-training.tasks.move_word_end")
local DeleteLine = require("nvim-training.tasks.delete_line")
local MoveAbsoluteLine = require("nvim-training.tasks.move_absolute_line")
local MoveWORD = require("nvim-training.tasks.move_WORD")

local exported_tasks = {
	MoveEndOfLine = MoveEndOfLine,
	SearchForward = SearchForward,
	MoveStartOfLine = MoveStartOfLine,
	MoveEndOfFile = MoveEndOfFile,
	MoveStartOfFile = MoveStartOfFile,
	Increment = Increment,
	CommentLine = CommentLine,
	CommentLineBlock = CommentLineBlock,
	MoveRandomXY = MoveRandomXY,
	DeleteInsideMatch = DeleteInsideMatch,
	YankInsideMatch = YankInsideMatch,
	MoveMatch = MoveMatch,
	MoveWordEnd = MoveWordEnd,
	MoveWord = MoveWord,
	DeleteLine = DeleteLine,
	MoveAbsoluteLine = MoveAbsoluteLine,
	MoveWORD = MoveWORD,
}

return exported_tasks
