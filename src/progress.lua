local Window = require("src.window")

local Progress = {}

function Progress:new()
	local newObj = { window = nil, progress_counter = 0, level = 0 }
	self.__index = self
	setmetatable(newObj, self)
	self.window = Window:new(25, 3, 5, 75)
	display_progress()
end

function Progress:display_progress()
	local new_text = "Current Progress: "
		.. tostring(progress.progress_counter)
		.. "\nCurrent Level: "
		.. tostring(current_level)
	self.window:update_window_text(new_text)
end

function Progress:update_streak()
	progress.progress_counter = progress.progress_counter + 1
	display_progress()
end

function Progress:end_streak()
	progress.progress_counter = 0
	display_progress()
end

function Progress:update_level(new_level)
	current_level = new_level
end

return Progress
