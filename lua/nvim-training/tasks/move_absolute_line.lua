local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local internal_config = require("nvim-training.internal_config")

local MoveAbsoluteLine = {}

MoveAbsoluteLine.__metadata = {
	autocmd = "CursorMoved",
	desc = "Move to the highlighted line",
	instructions = "Move to the highlighted line.",
	tags = "movement, line, vertical",
}
MoveAbsoluteLine.__index = MoveAbsoluteLine

setmetatable(MoveAbsoluteLine, { __index = Task })
function MoveAbsoluteLine:new()
	local base = Task:new()
	setmetatable(base, { __index = MoveAbsoluteLine })
	base.target_line = math.random(internal_config.header_length + 1, internal_config.header_length + 5)
	return base
end

function MoveAbsoluteLine:activate()
	local function _inner_update()
		utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()

		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		if cursor_pos[1] == self.target_line then
			vim.api.nvim_win_set_cursor(0, { cursor_pos[1] + 1, cursor_pos[2] })
		end

		cursor_pos = vim.api.nvim_win_get_cursor(0)

		local lines = vim.api.nvim_buf_get_lines(0, self.target_line - 1, self.target_line, false)
		local line_length = #lines[1]
		utility.create_highlight(self.target_line - 1, 0, line_length)
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveAbsoluteLine:deactivate(autocmd_callback_data)
	return self.target_line == vim.api.nvim_win_get_cursor(0)[1]
end

return MoveAbsoluteLine
