local LuaTask = require("nvim-training.tasks.lua_task")
local utility = require("nvim-training.utility")
local template_index = require("nvim-training.template_index")

local CommentLine = LuaTask:new()
CommentLine.__index = CommentLine
function CommentLine:new()
	local base = LuaTask:new()
	setmetatable(base, { __index = CommentLine })

	base.autocmd = "TextChanged"

	local function _inner_update()
		vim.cmd("sil e training.lua")
		utility.update_buffer_respecting_header(utility.load_template(template_index.LuaFunctions))
		vim.api.nvim_win_set_cursor(0, { 6, 7 })
	end
	vim.schedule_wrap(_inner_update)()

	return base
end

function CommentLine:teardown(autocmd_callback_data)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local new_line = utility.get_line(cursor_pos[1])
	return new_line:sub(1, 2) == "--"
end

function CommentLine:description()
	return "Change the current line into a single line comment."
end

return CommentLine
