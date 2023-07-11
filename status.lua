
local window_management = require('window')
local status ={}
local window_index

function status.init()

  	window_index= window_management.open_window(25, 1,1,25)
    window_management.update_window_text(window_index, "Current Progress: ".. tostring(progress_counter))
end

function status.update(input_text)
      window_management.update_window_text(window_index,input_text)
end

function status.end_streak()
    progress_counter = 0
    window_management.update_window_text(window_index,"Current Progress: ".. tostring(progress_counter))
end

return status