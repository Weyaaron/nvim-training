local exported_tasks = {
	AppendChar = require("nvim-training.tasks.append_char"),
	ChangeWord = require("nvim-training.tasks.change_word"),
	DeleteChar = require("nvim-training.tasks.delete_char"),
	Deletef = require("nvim-training.tasks.delete_f"),
	DeleteInsideMatch = require("nvim-training.tasks.delete_inside_match"),
	DeleteLine = require("nvim-training.tasks.delete_line"),
	DeleteWord = require("nvim-training.tasks.delete_word"),
	DeleteWORD = require("nvim-training.tasks.delete_WORD"),
	Increment = require("nvim-training.tasks.increment"),
	InsertChar = require("nvim-training.tasks.insert_char"),
	MoveAbsoluteLine = require("nvim-training.tasks.move_absolute_line"),
	MoveEndOfFile = require("nvim-training.tasks.move_end_of_file"),
	MoveEndOfLine = require("nvim-training.tasks.move_end_of_line"),
	Movef = require("nvim-training.tasks.move_f"),
	MoveF = require("nvim-training.tasks.move_F"),
	MoveMatch = require("nvim-training.tasks.move_match"),
	Moveo = require("nvim-training.tasks.move_o"),
	MoveO = require("nvim-training.tasks.move_O"),
	MoveStartOfFile = require("nvim-training.tasks.move_start_of_file"),
	MoveStartOfLine = require("nvim-training.tasks.move_start_of_line"),
	Movet = require("nvim-training.tasks.move_t"),
	MoveT = require("nvim-training.tasks.move_T"),
	MoveWordEnd = require("nvim-training.tasks.move_word_end"),
	MoveWord = require("nvim-training.tasks.move_word"),
	MoveWORD = require("nvim-training.tasks.move_WORD"),
	Paste = require("nvim-training.tasks.paste"),
	SearchForward = require("nvim-training.tasks.search_forward"),
	YankEndOfLine = require("nvim-training.tasks.yank_end_of_line"),
	YankInsideMatch = require("nvim-training.tasks.yank_inside_match"),
	YankIntoRegister = require("nvim-training.tasks.yank_into_register"),
	YankWord = require("nvim-training.tasks.yank_word"),
	YankWORD = require("nvim-training.tasks.yank_WORD"),
}

for i, v in pairs(exported_tasks) do
	v.name = i
end

return exported_tasks
