local Move = require("nvim-training.tasks.move")
local utility = require("nvim-training.utility")
local internal_config = require("nvim-training.internal_config")

local MoveAbsoluteLine = {}
MoveAbsoluteLine.__index = MoveAbsoluteLine
setmetatable(MoveAbsoluteLine, { __index = Move })
MoveAbsoluteLine.metadata = {
	autocmd = "CursorMoved",
	desc = "Move to the absolute line.",
	instructions = "Move to the absolute line with the highlight.",
	tags = { "movement", "line", "vertical" },
	input_template = "<counter>gg",
}

function MoveAbsoluteLine:new()
	local base = Move:new()
	setmetatable(base, { __index = MoveAbsoluteLine })
	base.cursor_target = { math.random(internal_config.header_length + 1, internal_config.header_length + 5), 0 }
	base.counter = base.cursor_target[1]
	return base
end

function MoveAbsoluteLine:activate()
	local function _inner_update()
		utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()

		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		if cursor_pos[1] == self.cursor_target[1] then
			vim.api.nvim_win_set_cursor(0, { cursor_pos[1] + 1, cursor_pos[2] })
		end
		cursor_pos = vim.api.nvim_win_get_cursor(0)

		local line_length = #utility.get_line(cursor_pos[1])
		utility.construct_highlight(self.cursor_target[1], 0, line_length)
		self.cursor_target = { self.cursor_target[1], cursor_pos[2] }
	end
	vim.schedule_wrap(_inner_update)()
end

return MoveAbsoluteLine
