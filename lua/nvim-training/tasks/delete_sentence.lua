local utility = require("nvim-training.utility")
local Delete = require("nvim-training.tasks.delete")
local tag_index = require("nvim-training.tag_index")

local DeleteSentence = {}

DeleteSentence.__index = DeleteSentence
setmetatable(DeleteSentence, { __index = Delete })
DeleteSentence.metadata = {
	autocmd = "TextChanged",
	desc = "Delete the textobject inner sentence.",
	instructions = "",
	tags = utility.flatten({ Delete.metadata.tags, tag_index.sentence }),
}

function DeleteSentence:new()
	local base = Delete:new()
	setmetatable(base, { __index = DeleteSentence })

	return base
end

function DeleteSentence:activate()
	local function _inner_update()
		local word_line = utility.construct_words_line()

		local sentence_boundary = math.random(10, 20)

		word_line = word_line:gsub("$.", " ")
		word_line = word_line:sub(0, sentence_boundary) .. ". " .. word_line:sub(sentence_boundary, #word_line)
		word_line = word_line:gsub("  ", " ")
		utility.set_buffer_to_rectangle_with_line(word_line)

		local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { current_cursor_pos[1], 22 })

		current_cursor_pos = vim.api.nvim_win_get_cursor(0)

		self.target_text = word_line:sub(sentence_boundary + 3, #word_line)

		utility.construct_highlight(current_cursor_pos[1], sentence_boundary, #word_line - sentence_boundary)
	end
	vim.schedule_wrap(_inner_update)()
end

function DeleteSentence:instructions()
	return "Delete the current inner sentence."
end
return DeleteSentence
