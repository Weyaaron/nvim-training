


local progress ={}

local display_buf, display_window, progress_counter

local function display_text(input_text)
	vim.api.nvim_buf_set_lines(display_buf,0, -1, false, input_text)
end


function play_levelup_sound()

    os.execute("play media/ding.flac 2> /dev/null")
end
function play_success_sound()

    os.execute("play media/click.flac 2> /dev/null")
end
function play_failure_sound()

    os.execute("play media/clack.flac 2> /dev/null")
end

local function append_display_text(input_text)

	old_text = vim.api.nvim_buf_get_lines(display_buf, 0,10, false)
	old_text[#old_text+1] = input_text[1]

	local table_as_text = table.concat(old_text, ' ')
	table_as_text = table_as_text .. ' ' .. input_text[1]

	vim.api.nvim_buf_set_lines(display_buf,0,-1, false, old_text)
	vim.api.nvim_win_set_height(display_window, #old_text+1)
end


function progress.init()

    current_window = vim.api.nvim_tabpage_get_win(0)

  	display_buf = vim.api.nvim_create_buf(false, true) -- create new emtpy buffer
  	display_window =window.open_window(display_buf)
	vim.api.nvim_set_current_win(current_window)
    display_text({"Current Progress: ".. tostring(progress_counter) })
end

function progress.update_streak()
    progress_counter = progress_counter +1
    display_text({"Current Progress: ".. tostring(progress_counter) })
	play_success_sound()

end

function progress.end_streak()
    progress_counter = 0
    display_text({"Current Progress: ".. tostring(progress_counter) })
	play_failure_sound()
end

return progress