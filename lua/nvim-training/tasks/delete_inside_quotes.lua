local utility = require("nvim-training.utility")
local Delete = require("nvim-training.tasks.delete")
local tag_index = require("nvim-training.tag_index")

local DeleteInsideQuotes = {}
DeleteInsideQuotes.__index = DeleteInsideQuotes
setmetatable(DeleteInsideQuotes, { __index = Delete })

DeleteInsideQuotes.metadata = {
	autocmd = "TextChanged",
	desc = "Delete inside the quotes.",
	instructions = "Delete inside the quotes.",
	tags = utility.flatten({ tag_index.quotes, tag_index.deletion }),
	-- input_template = "di<esc>",
	-- Todo: Enable for unit test
}
function DeleteInsideQuotes:new()
	local base = Delete:new()
	setmetatable(base, { __index = DeleteInsideQuotes })
	return base
end
function DeleteInsideQuotes:activate()
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

function DeleteInsideQuotes:instructions()
	return "Delete inside the quotes" .. utility.construct_register_description(self.target_register) .. "."
end
return DeleteInsideQuotes
