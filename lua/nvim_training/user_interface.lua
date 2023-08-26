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

	local window_text = current_task_sequence.current_level.current_round.current_task.desc .. "\n"

	local sequence_of_attempts = ""

	local round_length = vim.g.nvim_training.round_length
	local current_round = current_task_sequence.current_level.current_round
	local status_list = current_round:results()

	for i = 1, #status_list do
		local current_status = status_list[i]
		if current_status then
			sequence_of_attempts = sequence_of_attempts .. " ✓"
		else
			sequence_of_attempts = sequence_of_attempts .. " x"
		end
	end
	for i = #status_list, round_length do
		sequence_of_attempts = sequence_of_attempts .. " _"
	end

	window_text = window_text .. sequence_of_attempts

	window_text = window_text .. "\n\n" .. "Current Level: " .. current_task_sequence.level_index

	window_text = window_text
		.. "\n\n"
		.. "Current Round: "
		.. current_task_sequence.current_level.round_index
		.. "/"
		.. current_task_sequence.current_level.level_length

	self.window:update_window_text(window_text)
end

return UserInterface
--[[
	--Todo: Reintroduce


	--window_text = window_text .. "\n" .. self.help_text

--]]
