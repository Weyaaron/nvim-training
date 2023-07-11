
local window = require('window')
local absolute_line_task= require('absolute_line_task')
local progress = require('progress')



local function main(autocmd_args)

	absolute_line_task.init()



	local current_cursor = vim.api.nvim_win_get_cursor(0)
	local target_index = 22
	if target_index == current_cursor[1] then
		progress.update_streak()
	else
		progress.end_streak()
	end

	end

local function setup()

	progress.init()

	vim.api.nvim_create_autocmd({"CursorMoved"}, {
  		callback = main,
	})
end

setup()
