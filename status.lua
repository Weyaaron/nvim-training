


local status ={}

local display_buf, display_window, progress_counter

local function display_text(input_text)
	vim.api.nvim_buf_set_lines(display_buf,0, -1, false, {input_text})
end

function status.init()

    current_window = vim.api.nvim_tabpage_get_win(0)

  	display_buf = vim.api.nvim_create_buf(false, true) -- create new emtpy buffer
  	display_window =window.open_window(display_buf, 25, 1,1,25)
	vim.api.nvim_set_current_win(current_window)
    display_text({"Current Progress: ".. tostring(progress_counter) })
end

function status.update(input_text)
    display_text(input_text)
end

function progress.end_streak()
    progress_counter = 0
    display_text({ })
end

return progress