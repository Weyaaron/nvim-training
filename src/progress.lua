local Window = require("src.window")

local Progress = {}

function Progress:new()
	local newObj = { progress_counter = 0, level = 0 }
	self.__index = self
	setmetatable(newObj, self)
	self.window = Window:new(25, 25, 1, 50)
	newObj:display_progress()
	return newObj
end

function Progress:display_progress()
	local new_text = "Current Progress: "
		.. tostring(self.progress_counter)
		.. "\nCurrent Level: "
		.. tostring(self.level)
	self.window:update_window_text(new_text)
end

function Progress:update_streak()
	self.progress_counter = self.progress_counter + 1
	self:display_progress()
end

function Progress:end_streak()
	self.progress_counter = 0
	self:display_progress()
end

function Progress:update_level(new_level)
	self.level = new_level
end

return Progress
