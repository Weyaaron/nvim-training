window_management = {}

local api = vim.api
local window_table = {}

function window_management.open_window(width, height, row, col)
  window_buffer = vim.api.nvim_create_buf(false, true) -- create new emtpy buffer

  api.nvim_buf_set_option(window_buffer, 'bufhidden', 'wipe')

  -- set some options
  local opts = {
    style = "minimal",
    relative = "editor",
    anchor = 'NW',
    width = width,
    height =height,
    row = row,
    col = col,
    focusable =false,
  }

  -- and finally create it with buffer attached
  win = api.nvim_open_win(window_buffer, true, opts)

  window_table[#window_table+1] = {buffer = window_buffer, window = win}
  return #window_table
end

function window_management.update_window_text(window_index, new_text)

    target_buffer = window_table[window_index]['buffer']

	vim.api.nvim_buf_set_lines(target_buffer,0, -1, false, {new_text})
end


return window_management

