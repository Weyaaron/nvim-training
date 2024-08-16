local exported_tasks = {
	AppendChar = require("nvim-training.tasks.append_char"),
	DeleteChar = require("nvim-training.tasks.delete_char"),
	DeleteInsideMatch = require("nvim-training.tasks.delete_inside_match"),
	DeleteLine = require("nvim-training.tasks.delete_line"),
	Increment = require("nvim-training.tasks.increment"),
	InsertChar = require("nvim-training.tasks.insert_char"),
	MoveAbsoluteLine = require("nvim-training.tasks.move_absolute_line"),
	MoveEndOfFile = require("nvim-training.tasks.move_end_of_file"),
	MoveEndOfLine = require("nvim-training.tasks.move_end_of_line"),
	MoveF = require("nvim-training.tasks.move_F"),
	MoveMatch = require("nvim-training.tasks.move_match"),
	MoveRandom = require("nvim-training.tasks.move_random"),
	MoveStartOfFile = require("nvim-training.tasks.move_start_of_file"),
	MoveStartOfLine = require("nvim-training.tasks.move_start_of_line"),
	MoveT = require("nvim-training.tasks.move_T"),
	MoveWORD = require("nvim-training.tasks.move_WORD"),
	MoveWord = require("nvim-training.tasks.move_word"),
	MoveWordEnd = require("nvim-training.tasks.move_word_end"),
	MoveWordStart = require("nvim-training.tasks.move_word_start"),
	Movef = require("nvim-training.tasks.move_f"),
	Movet = require("nvim-training.tasks.move_t"),
	Paste = require("nvim-training.tasks.paste"),
	SearchForward = require("nvim-training.tasks.search_forward"),
	YankEndOfLine = require("nvim-training.tasks.yank_end_of_line"),
	YankInsideMatch = require("nvim-training.tasks.yank_inside_match"),
	YankIntoRegister = require("nvim-training.tasks.yank_into_register"),
	-- Barrier of tasks done, todo: Fix them
	-- CommentLineBlock = require("nvim-training.tasks.comment_line_block"),
	-- CommentLine = require("nvim-training.tasks.comment_line"), --Currently broken, cursor outside windwo
	--DeleteWord = require("nvim-training.tasks.delete_word"), Not quite done
	-- Todo: Migrate the remaining task to rectangle if possible
	-- MoveMark = require("nvim-training.tasks.move_mark"), --This one keeps being broken
	-- PlaceMark= require("nvim-training.tasks.place_mark"),
	-- MoveWordStart ?? How
	-- MoveyankWork ...
	-- CommentLineBlock = require("nvim-training.tasks.comment_line_block"),
	-- CommentLine = require("nvim-training.tasks.comment_line"),
}

return exported_tasks
