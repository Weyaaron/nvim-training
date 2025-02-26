local utility = require("nvim-training.utility")
local Delete = require("nvim-training.tasks.delete")
local tag_index = require("nvim-training.tag_index")

local DeleteMatch = {}
DeleteMatch.__index = DeleteMatch
setmetatable(DeleteMatch, { __index = Delete })

DeleteMatch.metadata = {
	autocmd = "TextChanged",
	desc = "Delete the current match.",
	instructions = "",
	tags = utility.flatten({ tag_index.deletion, tag_index.match, "register" }),
	input_template = "<target_register>d%",
}
function DeleteMatch:new()
	local base = Delete:new()
	setmetatable(base, { __index = DeleteMatch })
	return base
end
function DeleteMatch:activate()
	local function _inner_update()
		local left_bound = 25
		local right_bound = 30
		local line =
			utility.construct_line_with_bracket(utility.construct_random_bracket_pair(), left_bound, right_bound)
		utility.set_buffer_to_rectangle_with_line(line)

		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { cursor_pos[1], left_bound - 1 })
		self.target_text = line:sub(left_bound, right_bound)
		utility.construct_highlight(cursor_pos[1], left_bound, #self.target_text - 2)
	end
	vim.schedule_wrap(_inner_update)()
end

function DeleteMatch:instructions()
	return "Delete the current match" .. utility.construct_register_description(self.target_register) .. "."
end

return DeleteMatch
