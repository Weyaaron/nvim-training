local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")
local internal_config = require("nvim-training.internal_config")
local SearchForward = {}
SearchForward.__index = SearchForward

setmetatable(SearchForward, { __index = Task })
SearchForward.__metadata = {
	autocmd = "CursorMoved",
	desc = "Search forwards for a target-string.",
	instructions = "",
	tags = "search, movement, diagonal",
}
function SearchForward:new()
	local base = Task:new()
	setmetatable(base, { __index = SearchForward })
	base.search_target = ""

	return base
end

function SearchForward:activate()
	local function _inner_update()
		utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()

		vim.api.nvim_win_set_cursor(0, { internal_config.header_length + 1, math.random(5, 25) })

		local cursor_pos = vim.api.nvim_win_get_cursor(0)

		local lines = vim.api.nvim_buf_get_lines(0, cursor_pos[1] - 1, vim.api.nvim_buf_line_count(0), false)
		local line_offset = math.random(3, #lines - 1)
		local target_line = lines[line_offset]
		local words_in_line = utility.split_str(target_line, " ")
		local word_offset = math.random(1, #words_in_line)

		local search_len = 3
		local full_word = words_in_line[word_offset]
		self.search_target = string.sub(full_word, 0, search_len)
		local start_index_for_hl = string.find(target_line, self.search_target)

		utility.create_highlight(cursor_pos[1] + line_offset - 2, start_index_for_hl - 1, search_len)
		self.x_target = internal_config.header_length + line_offset
		self.y_target = start_index_for_hl
	end
	vim.schedule_wrap(_inner_update)()
end

function SearchForward:deactivate(autocmd_callback_data)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	vim.schedule_wrap(function()
		vim.cmd("noh")
	end)()
	return cursor_pos[1] == self.x_target and cursor_pos[2] == self.y_target - 1
end

function SearchForward:instructions()
	return "Search forwards for '" .. self.search_target .. "'"
end

return SearchForward
