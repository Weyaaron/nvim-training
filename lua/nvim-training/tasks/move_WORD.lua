local Move = require("nvim-training.tasks.move")
local template_index = require("nvim-training.template_index")
local user_config = require("nvim-training.user_config")
local utility = require("nvim-training.utility")
local movements = require("nvim-training.movements")

local MoveWORD = {}
MoveWORD.__index = MoveWORD
setmetatable(MoveWORD, { __index = Move })
MoveWORD.__metadata =
	{ autocmd = "CursorMoved", desc = "Move using W.", instructions = "Move using W.", tags = "movement, W, WORD" }

function MoveWORD:new()
	local base = Move:new()
	setmetatable(base, { __index = MoveWORD })
	base.target_y_pos = 0

	base.counter = 1
	if user_config.enable_counters then
		base.counter = math.random(2, 7)
	end
	return base
end

function MoveWORD:activate()
	local function _inner_update()
		local cursor_at_line_start = false
		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)

		--Todo: Move to box as well
		while not cursor_at_line_start do
			utility.update_buffer_respecting_header(utility.load_template(template_index.LoremIpsumWORDS))
			utility.move_cursor_to_random_point()
			current_cursor_pos = vim.api.nvim_win_get_cursor(0)
			cursor_at_line_start = current_cursor_pos[2] < 15

			local line = utility.get_line(current_cursor_pos[1])
			local char_at_cursor_pos = line:sub(current_cursor_pos[2] + 1, current_cursor_pos[2] + 1)
			if char_at_cursor_pos == " " then
				cursor_at_line_start = false
			end
		end

		self.cursor_target = movements.WORDS(self.counter)
		utility.create_highlight(current_cursor_pos[1] - 1, self.cursor_target[2], 1)
	end
	vim.schedule_wrap(_inner_update)()
end

function MoveWORD:instructions()
	return "Move " .. self.counter .. " WORD(s) using 'W'."
end
return MoveWORD
