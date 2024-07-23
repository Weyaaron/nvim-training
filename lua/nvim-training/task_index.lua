local exported_tasks = {
	CommentLine = require("nvim-training.tasks.comment_line"),
	-- CommentLineBlock = require("nvim-training.tasks.comment_line_block"),
	DeleteChar = require("nvim-training.tasks.delete_char"),
	DeleteInsideMatch = require("nvim-training.tasks.delete_inside_match"),
	DeleteLine = require("nvim-training.tasks.delete_line"),
	Increment = require("nvim-training.tasks.increment"),
	MoveAbsoluteLine = require("nvim-training.tasks.move_absolute_line"),
	MoveEndOfFile = require("nvim-training.tasks.move_end_of_file"),
	MoveEndOfLine = require("nvim-training.tasks.move_end_of_line"),
	MoveMatch = require("nvim-training.tasks.move_match"),
	MoveRandomXY = require("nvim-training.tasks.move_random_x_y"),
	MoveStartOfFile = require("nvim-training.tasks.move_start_of_file"),
	MoveStartOfLine = require("nvim-training.tasks.move_start_of_line"),
	MoveWORD = require("nvim-training.tasks.move_WORD"),
	MoveWord = require("nvim-training.tasks.move_word"),
	MoveWordStart = require("nvim-training.tasks.move_word_start"),
	MoveWordEnd = require("nvim-training.tasks.move_word_end"),
	Paste = require("nvim-training.tasks.paste"),
	SearchForward = require("nvim-training.tasks.search_forward"),
	YankEndOfLine = require("nvim-training.tasks.yank_end_of_line"),
	YankInsideMatch = require("nvim-training.tasks.yank_inside_match"),
	YankIntoRegister = require("nvim-training.tasks.yank_into_register"),
	InsertChar = require("nvim-training.tasks.insert_char"), -- Currently broken
	AppendChar = require("nvim-training.tasks.append_char"), -- Currently broken
	-- Barrier of tasks done, todo: Fix them
	--DeleteWord = require("nvim-training.tasks.delete_word"), Not quite done
	-- Todo: Migrate the remaining task to rectangle if possible
	-- MoveMark = require("nvim-training.tasks.move_mark"), --This one keeps being broken
	-- PlaceMark= require("nvim-training.tasks.place_mark"),
	-- MoveWordStart ?? How
	-- MoveyankWork ...
}

return exported_tasks
