local utility = require("nvim-training.utility")
local Yank = require("nvim-training.tasks.yank")
local tag_index = require("nvim-training.tag_index")

local YankInsideQuote = {}
YankInsideQuote.__index = YankInsideQuote
setmetatable(YankInsideQuote, { __index = Yank })

YankInsideQuote.metadata = {
	autocmd = "TextYankPost",
	desc = "Yank inside the quotes.",
	instructions = "Yank inside quotes.",
	tags = utility.flatten({ tag_index.yank, tag_index.quotes }),
}
function YankInsideQuote:new()
	local base = Yank:new()
	setmetatable(base, { __index = YankInsideQuote })
        base.target_quote = utility.construct_random_quote_pair()
    --TOdo: Rework to use a single quote
	return base
end
function YankInsideQuote:activate()
	local function _inner_update()
		local left_bound = 25
		local right_bound = 30
		local line = utility.construct_line_with_bracket(utility.construct_random_quote_pair(), left_bound, right_bound)
		utility.set_buffer_to_rectangle_with_line(line)

		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { cursor_pos[1], left_bound - 1 })
		self.target_text = line:sub(left_bound + 1, right_bound - 1)
		utility.construct_highlight(cursor_pos[1], left_bound, #self.target_text - 2)
	end

	vim.schedule_wrap(_inner_update)()
end

function YankInsideQuote:instructions()
	return "Yank inside the quotes" .. utility.construct_register_description(self.target_register) .. "."
end

return YankInsideQuote
