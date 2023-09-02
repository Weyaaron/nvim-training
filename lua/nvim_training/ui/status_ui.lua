local BaseUI = require("lua.nvim_training.ui.base_ui")

local StatusUI = {}
StatusUI.__index = StatusUI

function StatusUI:new()
	base = BaseUI:new(60, 9, 1, 75)
	setmetatable(base, { __index = self })
	return base
end

function StatusUI:display(current_task_sequence)
	local window_text = current_task_sequence.current_level.current_round.current_task.instruction .. "\n"

	local sequence_of_attempts = ""

	local round_length = vim.g.nvim_training.round_length
	local current_round = current_task_sequence.current_level.current_round
	local status_list = current_round:results()

	for i, v in pairs(status_list) do
		if v:completed() then
			sequence_of_attempts = sequence_of_attempts .. " ✓"
		else
			sequence_of_attempts = sequence_of_attempts .. " x"
		end
	end
	for i = #status_list, round_length - 1 do
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

return StatusUI
