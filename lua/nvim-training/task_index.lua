local exported_tasks = {
	CommentLineBlock = require("nvim-training.tasks.comment_line_block"),
	CommentLine = require("nvim-training.tasks.comment_line"),
	DeleteChar = require("nvim-training.tasks.delete_char"),
	DeleteInsideMatch = require("nvim-training.tasks.delete_inside_match"),
	Increment = require("nvim-training.tasks.increment"),
	MoveAbsoluteLine = require("nvim-training.tasks.move_absolute_line"),
	MoveEndOfFile = require("nvim-training.tasks.move_end_of_file"),
	MoveEndOfLine = require("nvim-training.tasks.move_end_of_line"),
	MoveMatch = require("nvim-training.tasks.move_match"),
	MoveRandomXY = require("nvim-training.tasks.move_random_x_y"),
	MoveStartOfFile = require("nvim-training.tasks.move_start_of_file"),
	MoveStartOfLine = require("nvim-training.tasks.move_start_of_line"),
	MoveWordEnd = require("nvim-training.tasks.move_word_end"),
	MoveWord = require("nvim-training.tasks.move_word"),
	MoveWORD = require("nvim-training.tasks.move_WORD"),
	SearchForward = require("nvim-training.tasks.search_forward"),
	YankInsideMatch = require("nvim-training.tasks.yank_inside_match"),
	--Barrier of tasks done, todo: Fix them
	-- DeleteChar = require("nvim-training.tasks.delete_char"),
	-- DeleteLine = require("nvim-training.tasks.delete_line"),
	-- DeleteWord = require("nvim-training.tasks.delete_word"),
	-- InsertChar= require("nvim-training.tasks.insert_char"), Currently broken
	-- Todo: Implement adding, probably similar problem = require("nvim-training.tasks.insert_char"), Currently broken
}

return exported_tasks
