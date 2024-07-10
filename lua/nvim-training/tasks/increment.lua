local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")

local Increment = Task:new()
Increment.__index = Increment

function Increment:new()
	local base = Task:new()
	setmetatable(base, { __index = Increment })

	base.autocmd = "CursorMoved"
	local modes = { "Increment", "Decrement" }
	base.inital_value = math.random(-100, 100)
	base.inital_value = 0
	base.mode = modes[math.random(#modes)]
	if base.mode == "Increment" then
		base.updated_value = base.inital_value + 1
	else
		base.updated_value = base.inital_value - 1
	end

	local function _inner_update()
		utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()
		local cursor_pos = vim.api.nvim_win_get_cursor(0)

		local lines = vim.api.nvim_buf_get_lines(0, cursor_pos[1] - 1, vim.api.nvim_buf_line_count(0), false)
		local left_half = lines[1]:sub(0, cursor_pos[2])
		local updated_line = left_half
			.. " "
			.. tostring(base.inital_value)
			.. " "
			.. string.sub(lines[1], cursor_pos[2], #lines[1])
		vim.api.nvim_buf_set_lines(0, cursor_pos[1] - 1, cursor_pos[1], false, { updated_line })
		vim.api.nvim_win_set_cursor(0, { cursor_pos[1], cursor_pos[2] + 1 })
	end
	vim.schedule_wrap(_inner_update)()

	return base
end

function Increment:teardown(autocmd_callback_data)
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

function Increment:description()
	return self.mode .. " the number at the cursor."
end

return Increment
