local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local internal_config = require("nvim-training.internal_config")
--Todo: Fix the zeros
local Increment = {}
Increment.__index = Increment
Increment.__metadata = {
	autocmd = "CursorMoved",
	desc = "Increment the value at the cursor.",
	instructions = "Increment/Decrement the value at the cursor.",
	tags = "increment, change, char",
}

setmetatable(Increment, { __index = Task })
function Increment:new()
	local base = Task:new()
	setmetatable(base, { __index = Increment })

	local modes = { "Increment", "Decrement" }
	base.inital_value = math.random(-100, 100)
	base.inital_value = 0
	base.mode = modes[math.random(#modes)]
	if base.mode == "Increment" then
		base.updated_value = base.inital_value + 1
	else
		base.updated_value = base.inital_value - 1
	end
	return base
end
function Increment:activate()
	local function _inner_update()
		local line = ""

		for i = 1, internal_config.line_length do
			if not i == internal_config.line_length / 2 then
				line = line .. " "
			else
				line = line .. "0"
			end
		end
		utility.set_buffer_to_rectangle_with_line(line)

		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		--Todo: Fix this!!!!!!!!!!!!!!!!!!!!!!
		local lines = vim.api.nvim_buf_get_lines(0, cursor_pos[1] - 1, vim.api.nvim_buf_line_count(0), false)
		local left_half = lines[1]:sub(0, cursor_pos[2])
		local updated_line = left_half
			.. " "
			.. tostring(self.inital_value)
			.. " "
			.. string.sub(lines[1], cursor_pos[2], #lines[1])
		vim.api.nvim_buf_set_lines(0, cursor_pos[1] - 1, cursor_pos[1], false, { updated_line })
		vim.api.nvim_win_set_cursor(0, { cursor_pos[1], cursor_pos[2] + 1 })
	end
	vim.schedule_wrap(_inner_update)()
end

function Increment:deactivate(autocmd_callback_data)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local lines = vim.api.nvim_buf_get_lines(0, cursor_pos[1] - 1, vim.api.nvim_buf_line_count(0), false)
	local words = utility.split_str(lines[1], " ")
	local word_found = false
	for i, v in pairs(words) do
		if v == tostring(self.updated_value) then
			word_found = true
		end
	end
	return word_found
end

function Increment:instructions()
	return self.mode .. " the number at the cursor."
end

return Increment
