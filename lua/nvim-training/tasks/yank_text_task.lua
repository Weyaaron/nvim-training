local utility = require("nvim-training.utility")
local current_config = require("nvim-training.current_config")
local Task = require("nvim-training.task")

local YankTask = Task:new({ target_text = "", autocmd = "TextYankPost" })
YankTask.__index = YankTask

function YankTask:yank_word()
	self.buffer_text = "\nLorem Ipsum \n"
	self.highlight_lenght = 6
end

function YankTask:yank_inside()
	-- local delimiter_options =
	self.buffer_text = "\nLorem Ipsum \n"
end

function YankTask:setup()
	-- local options = { YankTask.yank_inside, YankTask.yank_word }
	local options = { YankTask.yank_word }
	local choosen_option = math.random(#options)
	options[choosen_option](self)
	--Yank inside (,',",[,}
	-- Yank Word
	-- Yank back
	-- Yank end
	-- Yank W
	-- local new_text = utility.lorem_ipsum_lines(4)
	-- utility.update_buffer_respecting_header(new_text)
	utility.update_buffer_respecting_header(self.buffer_text)
	local function _inner_update()
		vim.api.nvim_win_set_cursor(0, { current_config.header_length + 2, 1 })
		--Todo: Set highlight properly!
		self.highlight = utility.create_highlight(current_config.header_length + 1, 1, 3)
	end
	vim.schedule_wrap(_inner_update)()
end

function YankTask:teardown(autocmd_callback_data)
	local event_data = vim.deepcopy(vim.v.event)

	utility.clear_highlight(self.highlight)
	return event_data.regcontents[1] == self.target_text
end

function YankTask:description()
	return "Yank the highlight"
end

return YankTask
