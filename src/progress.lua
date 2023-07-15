local window_management = require("src.window")

local progress = { progress_counter = 0 }
local display_window_index
local level = 1

local function display_progress()
	local new_text = "Current Progress: "
		.. tostring(progress.progress_counter)
		.. "\n"
		.. " Current Level: "
		.. tostring(current_level)
	window_management.update_window_text(display_window_index, new_text)
end

function progress.init()
	display_window_index = window_management.open_window(25, 3, 5, 75)
	display_progress()
end

function progress.update_streak()
	progress.progress_counter = progress.progress_counter + 1
	display_progress()
end

function progress.end_streak()
	progress.progress_counter = 0
	display_progress()
end

function progress.update_level(current_level)
	level = current_level
end

return progress
