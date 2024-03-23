if vim.g.loaded_training == 1 then
	print("Already loaded")
	return
end
vim.g.loaded_training = 1

local exposed_funcs = {}
local function construct_base_path()
	--https://stackoverflow.com/questions/6380820/get-containing-path-of-lua-file
	local function script_path()
		local str = debug.getinfo(1, "S").source:sub(2)
		local initial_result = str:match("(.*/)")
		return initial_result
	end

	local base_path = script_path() .. "../"
	return base_path
end

--This is a construct I am not entirely happy with. There
--might be a better way.
local base_path = construct_base_path()
vim.api.nvim_command("set runtimepath^=" .. base_path)

local utility = require("nvim-training.utility")
local current_config = require("nvim-training.current_config")

function exposed_funcs.setup(args)
	for i, v in pairs(args) do
		current_config[i] = v
	end
end

local MoveAbsoluteLine = require("nvim-training.tasks.move_absolute_line_task")
local MoveEndOfLine = require("nvim-training.tasks.move_to_end_of_line")
local MoveToMark = require("nvim-training.tasks.move_to_mark_task")

local YankWordTask = require("nvim-training.tasks.yank_word_task")
local MoveWordsTask = require("nvim-training.tasks.move_words_task")
local MoveStartOfLine = require("nvim-training.tasks.move_to_start_of_line")
local PasteTask = require("nvim-training.tasks.paste_task")
local YankIntoRegister = require("nvim-training.tasks.yank_into_register_task")
exposed_funcs.setup({
	task_list = { PasteTask },
})

local header = require("nvim-training.header")

local MoveWordsTask = require("nvim-training.tasks.move_words_task")
local YankEndOfLine = require("nvim-training.tasks.yank_end_of_line")
local DeleteLine = require("nvim-training.tasks.delete_line_task")
local MoveRandomXY = require("nvim-training.tasks.move_random_x_y")
local TestTask = require("nvim-training.tasks.test_task")

vim.api.nvim_buf_set_lines(0, 0, 25, false, {})
vim.api.nvim_win_set_cursor(0, { 1, 1 })

local task_count = 0
local success_count = 0
local failure_count = 0
local current_autocmd = -1
local toogle_discard = false
local current_task
local current_streak = 0
local max_streak = 0

header.store_key_value_in_header("#d", "Es gibt noch keine Aufgabe")
header.construct_header()

local function loop(autocmd_callback_data)
	vim.loop.sleep(200)
	if autocmd_callback_data then
		if autocmd_callback_data then
			--Todo: Extend after more event types are used.
			if autocmd_callback_data["event"] == "TextYankPost" then
				toogle_discard = false
			end
		end
		if toogle_discard then
			toogle_discard = false
			return
		end
		if current_autocmd > 0 then
			vim.api.nvim_del_autocmd(current_autocmd)
		end
		local task_res = current_task:teardown(autocmd_callback_data)
		task_count = task_count + 1
		if task_res then
			success_count = success_count + 1
			current_streak = current_streak + 1
			if current_streak >= max_streak then
				max_streak = current_streak
			end
		else
			failure_count = failure_count + 1
			if current_streak >= max_streak then
				max_streak = current_streak
			end
			current_streak = 0
		end
	end

	local index_of_new_task = math.random(#current_config.task_list)
	index_of_new_task = 1
	current_task = current_config.task_list[index_of_new_task]:new()

	header.store_key_value_in_header("_s_", success_count)
	header.store_key_value_in_header("_f_", failure_count)
	header.store_key_value_in_header("_streak_", current_streak)
	header.store_key_value_in_header("_maxstreak_", max_streak)
	header.store_key_value_in_header("_d_", current_task:description())
	header.store_key_value_in_header("_d_", current_task:description())

	vim.schedule_wrap(function()
		header.construct_header()
	end)()
	current_autocmd = vim.api.nvim_create_autocmd({ current_task.autocmd }, { callback = loop })
	toogle_discard = true
end

vim.api.nvim_create_user_command("Training", function()
	loop()
end, {})

return exposed_funcs
