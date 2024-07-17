local exported_tasks = {
	MoveEndOfLine = require("nvim-training.tasks.move_end_of_line"),
	MoveStartOfLine = require("nvim-training.tasks.move_start_of_line"),
	MoveStartOfFile = require("nvim-training.tasks.move_start_of_file"),
	MoveEndOfFile = require("nvim-training.tasks.move_end_of_file"),
	SearchForward = require("nvim-training.tasks.search_forward"),
	Increment = require("nvim-training.tasks.increment"),
	CommentLine = require("nvim-training.tasks.comment_line"),
	CommentLineBlock = require("nvim-training.tasks.comment_line_block"),
	MoveRandomXY = require("nvim-training.tasks.move_random_x_y"),
	DeleteInsideMatch = require("nvim-training.tasks.delete_inside_match"),
	YankInsideMatch = require("nvim-training.tasks.yank_inside_match"),
	MoveMatch = require("nvim-training.tasks.move_match"),
	MoveWord = require("nvim-training.tasks.move_word"),
	MoveWordEnd = require("nvim-training.tasks.move_word_end"),
	DeleteLine = require("nvim-training.tasks.delete_line"),
	MoveAbsoluteLine = require("nvim-training.tasks.move_absolute_line"),
	MoveWORD = require("nvim-training.tasks.move_WORD"),
}

return exported_tasks
