local LuaTask = require("nvim-training.tasks.lua_task")
local utility = require("nvim-training.utility")
local template_index = require("nvim-training.template_index")

local CommentLineBlock = LuaTask:new()
CommentLineBlock.__index = CommentLineBlock

function CommentLineBlock:new()
	local base = LuaTask:new()
	setmetatable(base, { __index = CommentLineBlock })

	base.autocmd = "TextChanged"

	local function _inner_update()
		vim.cmd("sil e training.lua")
		utility.update_buffer_respecting_header(utility.load_template(template_index.LuaFunctions))

		vim.api.nvim_win_set_cursor(0, { 6, 7 })
	end
	vim.schedule_wrap(_inner_update)()

	return base
end

function CommentLineBlock:teardown()
	local new_line = utility.get_line(vim.api.nvim_win_get_cursor(0)[1])
	return new_line:sub(1, 4) == "--[["
end

function CommentLineBlock:description()
	return "Change the current line into a block comment"
end

return CommentLineBlock
