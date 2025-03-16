local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")

local JoinLines = {}
JoinLines.__index = JoinLines
JoinLines.metadata = {
	autocmd = "TextChanged",
	desc = "Join the current line with the line below.",
	instructions = "Join the current line with the line below.",
	tags = { "change", "line", "join", "J" },
	input_template = "J",
}

setmetatable(JoinLines, { __index = Task })
function JoinLines:new()
	local base = Task:new()
	setmetatable(base, JoinLines)

	local initial_line = utility.construct_words_line()
	local next_line = utility.construct_words_line()
	base.target_line = initial_line .. " " .. next_line
	base.initial_line = initial_line .. "\n" .. next_line
	return base
end
function JoinLines:activate()
	local function _inner_update()
		utility.set_buffer_to_rectangle_with_line(self.initial_line)
	end
	vim.schedule_wrap(_inner_update)()
end

function JoinLines:deactivate()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local current_line = utility.get_line(cursor_pos[1])
	return self.target_line == current_line
end

return JoinLines
