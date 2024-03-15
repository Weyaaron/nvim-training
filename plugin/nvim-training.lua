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

local header = require("nvim-training.header")

local YankTask = require("nvim-training.tasks.yank_text_task")
local MoveWordsTask = require("nvim-training.tasks.move_words_tasks")
local MoveAbsoluteLine = require("nvim-training.tasks.move_absolute_line_task")
local MoveEndOfLine = require("nvim-training.tasks.move_to_end_of_line")
local MoveStartOfLine = require("nvim-training.tasks.move_to_start_of_line")
local YankEndOfLine = require("nvim-training.tasks.yank_end_of_line")
local DeleteLine = require("nvim-training.tasks.delete_line_task")
local MoveToMark = require("nvim-training.tasks.move_to_mark_task")
local MoveRandomXY = require("nvim-training.tasks.move_random_x_y")
local TestTask = require("nvim-training.tasks.test_task")

-- local tasks = { DeleteLine, YankEndOfLine, MoveStartOfLine }
local tasks = { MoveRandomXY }
local tasks = { TestTask }
vim.api.nvim_buf_set_lines(0, 0, 25, false, {})

local current_task
local task_count = 0
local success_count = 0
local failure_count = 0
local current_autocmd = -1
local toogle_discard = false

header.store_key_value_in_header("#d", "Es gibt noch keine Aufgabe")
header.construct_header()
local function update_buffer_to_new_task()
	function _inner_update()
		vim.loop.sleep(100)
		utility.update_buffer_respecting_header("\n\n\n\n")
		header.construct_header()
	end
	vim.schedule_wrap(_inner_update)()
end

local function loop(autocmd_callback_data)
	vim.loop.sleep(100)
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
	if current_task then
		local task_res = current_task:teardown(autocmd_callback_data)
		task_count = task_count + 1
		if task_res then
			success_count = success_count + 1
		else
			failure_count = failure_count + 1
		end
	end

	local index_of_new_task = math.random(#tasks)
	index_of_new_task = 1
	current_task = tasks[index_of_new_task]:new()

	header.store_key_value_in_header("_s", success_count)
	header.store_key_value_in_header("_f", failure_count)
	header.store_key_value_in_header("#d", current_task:description())
	update_buffer_to_new_task()
	current_task:setup()

	header.store_key_value_in_header("#d", current_task:description())
	header.construct_header()
	current_autocmd = vim.api.nvim_create_autocmd({ current_task.autocmd }, { callback = loop })
	toogle_discard = true
end
local function start_training()
	update_buffer_to_new_task()
	loop()
end

function exposed_funcs.setup(args)
	for i, v in pairs(args) do
		current_config[i] = v
	end
end

vim.api.nvim_create_user_command("Training", start_training, {})

return exposed_funcs
