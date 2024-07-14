local Task = require("nvim-training.task")
local utility = require("nvim-training.utility")

local internal_config = require("nvim-training.internal_config")
local ExpandSnippet = Task:new()

ExpandSnippet.__index = ExpandSnippet

function ExpandSnippet:new()
	local base = Task:new()
	setmetatable(base, { __index = ExpandSnippet })

	base.target_line = internal_config.header_length + 1
	base.autocmd = "InsertLeave"
	local function _inner_update()
		local text = "sn\n"
		utility.update_buffer_respecting_header(text)

		vim.api.nvim_win_set_cursor(0, { base.target_line, 0 })
	end
	vim.schedule_wrap(_inner_update)()
	return base
end

function ExpandSnippet:teardown(autocmd_callback_data)
	local ith_line = utility.get_line(self.target_line)
	print("Line" .. ith_line)
end

function ExpandSnippet:description()
	return "Expand the snippet at the cursor into 'sn a b c'"
end

return ExpandSnippet
