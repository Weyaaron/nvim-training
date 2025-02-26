local utility = require("nvim-training.utility")
local Yank = require("nvim-training.tasks.yank")
local tag_index = require("nvim-training.tag_index")

local YankInsideBlock = {}
YankInsideBlock.__index = YankInsideBlock
setmetatable(YankInsideBlock, { __index = Yank })

YankInsideBlock.metadata = {
	autocmd = "TextYankPost",
	desc = "Yank inside the block.",
	instructions = "Yank inside block.",
	tags = utility.flatten({ tag_index.yank, tag_index.block }),
	input_template = "<target_register>yib",
}
function YankInsideBlock:new()
	local base = Yank:new()
	setmetatable(base, { __index = YankInsideBlock })
	return base
end
function YankInsideBlock:activate()
	local function _inner_update()
		local left_bound = 25
		local right_bound = 30
		local line = utility.construct_line_with_bracket({ "(", ")" }, left_bound, right_bound)
		utility.set_buffer_to_rectangle_with_line(line)

		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { cursor_pos[1], left_bound + 1 })
		self.target_text = line:sub(left_bound + 1, right_bound - 1)
		utility.construct_highlight(cursor_pos[1], left_bound, #self.target_text - 2)
	end

	vim.schedule_wrap(_inner_update)()
end

function YankInsideBlock:instructions()
	return "Yank inside the current block" .. utility.construct_register_description(self.target_register) .. "."
end
return YankInsideBlock
