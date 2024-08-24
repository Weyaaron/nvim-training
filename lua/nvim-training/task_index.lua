local exported_tasks = {
	AppendChar = require("nvim-training.tasks.append_char"),
	ChangeWord = require("nvim-training.tasks.change_word"),
	DeleteChar = require("nvim-training.tasks.delete_char"),
	DeleteInsideMatch = require("nvim-training.tasks.delete_inside_match"),
	DeleteLine = require("nvim-training.tasks.delete_line"),
	DeleteWORD = require("nvim-training.tasks.delete_WORD"),
	DeleteWord = require("nvim-training.tasks.delete_word"),
	Delete_f = require("nvim-training.tasks.delete_f"),
	Increment = require("nvim-training.tasks.increment"),
	InsertChar = require("nvim-training.tasks.insert_char"),
	MoveAbsoluteLine = require("nvim-training.tasks.move_absolute_line"),
	MoveEndOfFile = require("nvim-training.tasks.move_end_of_file"),
	MoveEndOfLine = require("nvim-training.tasks.move_end_of_line"),
	MoveF = require("nvim-training.tasks.move_F"),
	MoveMatch = require("nvim-training.tasks.move_match"),
	MoveStartOfFile = require("nvim-training.tasks.move_start_of_file"),
	MoveStartOfLine = require("nvim-training.tasks.move_start_of_line"),
	MoveT = require("nvim-training.tasks.move_T"),
	MoveWORD = require("nvim-training.tasks.move_WORD"),
	MoveWord = require("nvim-training.tasks.move_word"),
	MoveWordEnd = require("nvim-training.tasks.move_word_end"),
	Move_O = require("nvim-training.tasks.move_O"),
	Move_o = require("nvim-training.tasks.move_o"),
	Movef = require("nvim-training.tasks.move_f"),
	Movet = require("nvim-training.tasks.move_t"), --Todo: Rework internals
	Paste = require("nvim-training.tasks.paste"),
	SearchForward = require("nvim-training.tasks.search_forward"), --Todo: Rework into movement
	YankEndOfLine = require("nvim-training.tasks.yank_end_of_line"),
	YankInsideMatch = require("nvim-training.tasks.yank_inside_match"),
	YankIntoRegister = require("nvim-training.tasks.yank_into_register"),
	YankWORD = require("nvim-training.tasks.yank_WORD"),
	YankWord = require("nvim-training.tasks.yank_word"),
	--MoveRandom = require("nvim-training.tasks.move_random"), Issue: Not a single line
	-- Barier II
	-- Barrier of tasks done, todo: Fix them
	-- CommentLineBlock = require("nvim-training.tasks.comment_line_block"),
	-- CommentLine = require("nvim-training.tasks.comment_line"), --Currently broken, cursor outside windwo
	-- Todo: Migrate the remaining task to rectangle if possible
	-- MoveMark = require("nvim-training.tasks.move_mark"), --This one keeps being broken
	-- PlaceMark= require("nvim-training.tasks.place_mark"),
	-- MoveWordStart ?? How
	-- MoveyankWork ...
	-- CommentLineBlock = require("nvim-training.tasks.comment_line_block"),
	-- CommentLine = require("nvim-training.tasks.comment_line"),
	-- OpenWindow = require("nvim-training.tasks.open_window"),
	-- MoveWORDEnd = require("nvim-training.tasks.move_WORD_end"),
}

for i, v in pairs(exported_tasks) do
	v.name = i
end

return exported_tasks
