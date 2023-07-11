

local absolute_line_task= require('absolute_line_task')
local progress = require('progress')
local status = require('status')

local function main(autocmd_args)

	status.update(absolute_line_task.desc)

	if absolute_line_task.check() then
		progress.update_streak()
		absolute_line_task.init()
		status.update(absolute_line_task.desc)
	else
		progress.end_streak()
	end
	absolute_line_task.teardown()


end

local function setup()
	current_window = vim.api.nvim_tabpage_get_win(0)

	progress.init()
	status.init()
	absolute_line_task.init()
	vim.api.nvim_set_current_win(current_window)

	vim.api.nvim_create_autocmd({"CursorMoved"}, {
  		callback = main,
	})
end

setup()
