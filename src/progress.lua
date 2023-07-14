local window_management = require("src.window")

local progress = {}
local display_window_index
local progress_counter = 0

local function display_progress()
	window_management.update_window_text(display_window_index, "Current Progress: " .. tostring(progress_counter))
end

function progress.init()
	display_window_index = window_management.open_window(25, 1, 5, 75)
	display_progress()
end

function progress.update_streak()
	progress_counter = progress_counter + 1
	display_progress()
end

function progress.end_streak()
	progress_counter = 0
	display_progress()
end

return progress
