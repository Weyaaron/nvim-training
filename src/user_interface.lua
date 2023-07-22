local Window = require("src.window")

local UserInterface = {}

function UserInterface:new()
	local newObj = { progress_counter = 0 }
	self.__index = self
	setmetatable(newObj, self)
	self.window = Window:new(50, 3, 1, 25)
	newObj.call_counter = 0
	return newObj
end

function UserInterface:display(current_task_sequence)
	local window_text = "\n" .. current_task_sequence.current_task.desc .. "\n"

	local sequence_of_attempts = ""
	for i, v in pairs(current_task_sequence.status_list) do
		if v then
			sequence_of_attempts = sequence_of_attempts .. "t"
		else
			sequence_of_attempts = sequence_of_attempts .. "f"
		end
	end
	window_text = window_text .. sequence_of_attempts

	self.window:update_window_text(window_text)
end

return UserInterface
