local utility = require("nvim-training.utility")
local Move = require("nvim-training.tasks.move")
local tag_index = require("nvim-training.tag_index")

local MoveLinesUp = {}
setmetatable(MoveLinesUp, { __index = Move })
MoveLinesUp.__index = MoveLinesUp

MoveLinesUp.metadata = {
	autocmd = "CursorMoved",
	desc = "Move multiple lines up.",
	instructions = "",
	tags = utility.flatten({ tag_index.movement, tag_index.lines_up }),
	input_template = "<counter>k",
}
function MoveLinesUp:new()
	local base = Move:new()
	setmetatable(base, { __index = MoveLinesUp })
	return base
end

function MoveLinesUp:activate()
	local function _inner_update()
		local line = utility.construct_words_line()
		--This is somewhat of hack, but we need this to get back to the center of the screen
		utility.set_buffer_to_rectangle_with_line(line)
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		local x_base = cursor_pos[1]
		local x_limit = (cursor_pos[1] + self.counter * 2) + 2
		local x_center = (cursor_pos[1] + self.counter + 2) + 1
		local paragraph = utility.construct_words_line()
		for i = x_base, x_limit - 1 do
			paragraph = paragraph .. "\n" .. utility.construct_words_line()
		end
		utility.set_buffer_to_rectangle_with_line(paragraph)
		vim.api.nvim_win_set_cursor(0, { x_center, cursor_pos[2] })
		self.cursor_target = { x_center - self.counter, cursor_pos[2] }
		utility.construct_highlight(self.cursor_target[1], 0, #utility.get_line(self.cursor_target[1]))
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveLinesUp:instructions()
	return "Move " .. self.counter .. " lines up."
end
return MoveLinesUp
