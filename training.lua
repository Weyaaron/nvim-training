
local window = require('window')
local absolute_line_task= require('absolute_line_task')

local display_buf, display_window

local function display_text(input_text)
	vim.api.nvim_buf_set_lines(display_buf,0, -1, false, input_text)
end


local function append_display_text(input_text)

	old_text = vim.api.nvim_buf_get_lines(display_buf, 0,10, false)
	old_text[#old_text+1] = input_text[1]

	local table_as_text = table.concat(old_text, ' ')
	table_as_text = table_as_text .. ' ' .. input_text[1]


	vim.api.nvim_buf_set_lines(display_buf,0,-1, false, old_text)
	vim.api.nvim_win_set_height(display_window, #old_text+1)
end

local function main(autocmd_args)

	absolute_line_task.init()
	--display_text({"Movement"})
	append_display_text({'Movementaaaa'})

	local current_cursor = vim.api.nvim_win_get_cursor(0)
	local target_index = 22
	if target_index == current_cursor[1] then
		display_text(absolute_line_task.desc)
	end

end

local function setup()
	current_window = vim.api.nvim_tabpage_get_win(0)

  	display_buf = vim.api.nvim_create_buf(false, true) -- create new emtpy buffer
  	display_window =window.open_window(display_buf)
	vim.api.nvim_set_current_win(current_window)

	vim.api.nvim_create_autocmd({"CursorMoved"}, {
  		callback = main,
	})
end

setup()
