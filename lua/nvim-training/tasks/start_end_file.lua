local utility = require("nvim-training.utility")
local Task = require("nvim-training.task")
local current_config = require("nvim-training.current_config")

local MoveToFileBounds = {}
MoveToFileBounds.__index = MoveToFileBounds

function MoveToFileBounds:new()
	local base = Task:new()

	setmetatable(base, { __index = MoveToFileBounds })
	self.autocmd = "CursorMoved"
	local options = { "G", "gg" }
	self.choosen_mode = math.random(2)
	self.choosen_option = options[self.choosen_mode]
	local function _inner_update()
		utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()
	end
	vim.schedule_wrap(_inner_update)()
	return self
end

function MoveToFileBounds:teardown(autocmd_callback_data)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)

	if self.choosen_option == "G" then
		return cursor_pos[1] == vim.api.nvim_buf_line_count(0)
	end

	return cursor_pos[1] == 0
end

function MoveToFileBounds:description()
	if self.choosen_option == "G" then
		return "Navigate to the bottom of the file."
	end
	return "Navigate  to the top of the file."
end

return MoveToFileBounds
