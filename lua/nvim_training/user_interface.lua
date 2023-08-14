local Window = require("nvim_training.window")

local UserInterface = {}
UserInterface.__index = UserInterface


function UserInterface:new()
	local base = { progress_counter = 0 }
	setmetatable(base, { __index = self })
	base.window = Window:new(50, 3, 1, 75)
	base.call_counter = 0
	return base
end

function UserInterface:display(current_task_sequence)
	local window_text = "\n" .. current_task_sequence.current_task.desc .. "\n"

	local sequence_of_attempts = ""
	for _, v in pairs(current_task_sequence.status_list) do
		if v then
			sequence_of_attempts = sequence_of_attempts .. " t"
		else
			sequence_of_attempts = sequence_of_attempts .. " f"
		end
	end
	window_text = window_text .. sequence_of_attempts

	self.window:update_window_text(window_text)
end

return UserInterface
