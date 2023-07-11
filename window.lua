window = {}

local api = vim.api

function window.open_window(window_buffer)
  local win

  api.nvim_buf_set_option(window_buffer, 'bufhidden', 'wipe')

  -- get dimensions
  local width = api.nvim_get_option("columns")
  local height = api.nvim_get_option("lines")

  -- calculate our floating window size
  local win_height = math.ceil(height * 0.8 - 4) / 4
  win_height = 1
  local win_width = math.ceil(width * 0.8) 
  win_width = 2

  -- and its starting position
  local row = math.ceil((height - win_height) / 2 - 1)
  local col = math.ceil((width - win_width) / 4) 

  -- set some options
  local opts = {
    style = "minimal",
    relative = "cursor",
    anchor = 'SE',
    width = 25,
    height =1,
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

