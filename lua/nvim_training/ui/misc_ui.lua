local BaseUI = require("nvim_training.ui.base_ui")

local MiscUi = {}
MiscUi.__index = MiscUi

function MiscUi:new()
	local base = BaseUI:new(60, 9, 11, 75)
	setmetatable(base, { __index = self })
	return base
end

function MiscUi:display(current_task_sequence)
	local window_text = ""

	for i, level_el in pairs(current_task_sequence.previous_levels) do
		for j, round_el in pairs(level_el.previous_rounds) do
			for k, result_el in pairs(round_el:results()) do
				window_text = window_text
					.. tostring(i)
					.. ","
					.. tostring(j)
					.. ","
					.. tostring(k)
					.. ","
					.. tostring(result_el:completed())
					.. "\n"
			end
		end
	end

	self.window:update_window_text(window_text)
end

return MiscUi
