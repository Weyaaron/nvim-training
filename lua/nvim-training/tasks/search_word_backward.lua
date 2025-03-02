local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local SearchWordBackward = {}
SearchWordBackward.__index = SearchWordBackward

setmetatable(SearchWordBackward, { __index = Task })
SearchWordBackward.metadata = {
	autocmd = "CursorMoved",
	desc = "Search backwards for the word at the cursor.",
	instructions = "",
	tags = { "search", "movement", "backward" },
	-- input_template = "#<search_target><cr>",
	-- input_template = "?<<search_target>><cr>",
	-- Currently not viable to test, might be fixed some day
	input_template = "",
}
function SearchWordBackward:new()
	local base = Task:new()
	setmetatable(base, { __index = SearchWordBackward })
	base.search_target = ""

	base.subword_length = 4
	base.initial_cursor_pos = 55
	base.data_for_search = utility.construct_data_search(base.subword_length, 0, 30)
	base.initial_line = base.data_for_search[1]
	base.search_target = base.data_for_search[2]
	base.x_target = base.data_for_search[3]
	return base
end

function SearchWordBackward:activate()
	local function _inner_update()
		utility.set_buffer_to_rectangle_with_line(self.data_for_search[1])

		local cursor_pos = vim.api.nvim_win_get_cursor(0)

		local new_line = self.initial_line:sub(1, self.initial_cursor_pos)
			.. " "
			.. self.data_for_search[2]
			.. " "
			.. self.initial_line:sub(self.initial_cursor_pos + self.subword_length, #self.initial_line)
		utility.set_buffer_to_rectangle_with_line(new_line)

		vim.api.nvim_win_set_cursor(0, { cursor_pos[1], self.initial_cursor_pos + 1 })

		cursor_pos = vim.api.nvim_win_get_cursor(0)
		utility.construct_highlight(cursor_pos[1], self.data_for_search[3], self.subword_length)
	end
	vim.schedule_wrap(_inner_update)()
end

function SearchWordBackward:deactivate()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	vim.schedule_wrap(function()
		vim.cmd("noh")
	end)()
	return cursor_pos[2] == self.x_target
end

function SearchWordBackward:instructions()
	return "Search for the word unter the cursor: '" .. self.search_target .. "'"
end

return SearchWordBackward
