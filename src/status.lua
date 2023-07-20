local Window = require("src.window")

local Status = {}

function Status:new()
	local newObj = { window = nil }
	self.__index = self
	setmetatable(newObj, self)

	self.window = Window:new(25, 5, 5, 50)
	self.window:update_window_text("Neue Aufgabe")
	return newObj
end

function Status:update(input_text)
	self.window:update_window_text(window_index, input_text .. "\n")
end

return Status
