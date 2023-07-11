window = {}

local api = vim.api
local win


function window.open_window(window_buffer, width, height,row, col)

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
  win = api.nvim_open_win(window_buffer
  , true, opts)
  return win
end



return window

