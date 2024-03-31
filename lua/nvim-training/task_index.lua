local MoveAbsoluteLine = require("nvim-training.tasks.move_absolute_line_task")
local MoveEndOfLine = require("nvim-training.tasks.move_to_end_of_line")
local MoveToMark = require("nvim-training.tasks.move_to_mark_task")
local MoveToFileBounds = require("nvim-training.tasks.start_end_file")

local YankWordTask = require("nvim-training.tasks.yank_word_task")
local MoveWordsTask = require("nvim-training.tasks.move_words_task")
local MoveStartOfLine = require("nvim-training.tasks.move_to_start_of_line")
local PasteTask = require("nvim-training.tasks.paste_task")
local YankIntoRegister = require("nvim-training.tasks.yank_into_register_task")

local MoveWordsTask = require("nvim-training.tasks.move_words_task")
local YankEndOfLine = require("nvim-training.tasks.yank_end_of_line")
local DeleteLine = require("nvim-training.tasks.delete_line_task")
local MoveRandomXY = require("nvim-training.tasks.move_random_x_y")
local TestTask = require("nvim-training.tasks.test_task")

local exported_tasks = {
	MoveEndOfLine = MoveEndOfLine,
	MoveStartOfLine = MoveStartOfLine,
	MoveToFileBounds = MoveToFileBounds,
	MoveRandomXY = MoveRandomXY,
	TestTask = TestTask,
	YankEndOfLine = YankEndOfLine,
}

for i, v in pairs(exported_tasks) do
	exported_tasks[string.lower(i)] = exported_tasks[i]
end
-- print('len' + tostring(#name_module_dict))

return exported_tasks