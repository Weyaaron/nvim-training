
local window_management = require('window')
local status ={}
local window_index

function status.init()

  	window_index= window_management.open_window(25, 1,1,75)
    window_management.update_window_text(window_index, "Neue Aufgabe")
end

function status.update(input_text)
      window_management.update_window_text(window_index,input_text)
end



return status