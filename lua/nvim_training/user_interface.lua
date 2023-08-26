local Window = require("nvim_training.window")

local UserInterface = {}
UserInterface.__index = UserInterface

function UserInterface:new()
	local base = {}
	setmetatable(base, { __index = self })
	base.progress_counter = 0
	base.window_width = 60
	base.window = Window:new(base.window_width, 9, 1, 75)
	base.call_counter = 0
	--Todo: Fix the number, not quite sure how
	base.help_text = "Finish 7 tasks in the current sequence successfully to reach a new level."
	base.window_width = 60
	return base
end

function UserInterface:display(current_task_sequence)
	--Todo: Implement this as a progress indicator
	local head = ""
	local scale = 3
	for i = 1, current_task_sequence.current_round do
		for v = 1, scale do
			head = head .. "-"
		end
	end
	--This long string sucks
	local window_text = current_task_sequence.current_level.current_round.current_task.desc .. "\n"

	local sequence_of_attempts = ""

	local max_streak_per_level = 3
	--Doing it this way sucks, this will be improved upon
	local status_list = current_task_sequence.current_level.current_round.status_list

	for i = 1, #status_list do
		local current_status = status_list[i]
		if current_status then
			sequence_of_attempts = sequence_of_attempts .. " ✓"
		else
			sequence_of_attempts = sequence_of_attempts .. " x"
		end
	end
	for i = #current_task_sequence.status_list, max_streak_per_level do
		sequence_of_attempts = sequence_of_attempts .. " _"
	end

	window_text = window_text .. sequence_of_attempts

	window_text = window_text .. "\n\n" .. "Current Level: " .. current_task_sequence.level_index

	window_text = window_text
		.. "\n\n"
		.. "Current Round: "
		.. current_task_sequence.current_level.round_index
		.. "/"
		.. current_task_sequence.current_level.max_rounds

	self.window:update_window_text(window_text)
end

return UserInterface
--[[
	--Todo: Reintroduce


	--window_text = window_text .. "\n" .. self.help_text

--]]
