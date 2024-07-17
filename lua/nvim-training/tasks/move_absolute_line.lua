local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local internal_config = require("nvim-training.internal_config")

local MoveAbsoluteLine = Task:new()
MoveAbsoluteLine.__index = MoveAbsoluteLine

function MoveAbsoluteLine:new()
	local base = Task:new()
	base.autocmd = "CursorMoved"

	setmetatable(base, { __index = MoveAbsoluteLine })
	base.target_line = math.random(internal_config.header_length + 1, internal_config.header_length + 5)
	local function _inner_update()
		utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()

		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		if cursor_pos[1] == base.target_line then
			vim.api.nvim_win_set_cursor(0, { cursor_pos[1] + 1, cursor_pos[2] })
		end

		cursor_pos = vim.api.nvim_win_get_cursor(0)

		local lines = vim.api.nvim_buf_get_lines(0, base.target_line - 1, base.target_line, false)
		local line_length = #lines[1]
		utility.create_highlight(base.target_line - 1, 0, line_length)
	end
	vim.schedule_wrap(_inner_update)()
	return base
end

function MoveAbsoluteLine:teardown(autocmd_callback_data)
	return self.target_line == vim.api.nvim_win_get_cursor(0)[1]
end

function MoveAbsoluteLine:description()
	return "Move to Line " .. self.target_line
end

return MoveAbsoluteLine
