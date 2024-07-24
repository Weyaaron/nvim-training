local TaskLua = require("nvim-training.tasks.task_lua")
local utility = require("nvim-training.utility")
local template_index = require("nvim-training.template_index")

local CommentLine = {}
CommentLine.__index = CommentLine

setmetatable(CommentLine, { __index = TaskLua })

CommentLine.__metadata = {
	autocmd = "TextChanged",
	desc = "Change the current line into a single line comment.",
	instructions = "Change the current line into a single line comment.",
	notes = "Not available in vanilla-vim, needs plugin.",
	tags = "programming, plugin, change, commenting",
}
function CommentLine:new()
	local base = TaskLua:new()
	setmetatable(base, { __index = CommentLine })
	return base
end
function CommentLine:activate()
	local function _inner_update()
		vim.cmd("sil e training.lua")
		utility.update_buffer_respecting_header(utility.load_template(template_index.LuaFunctions))
		vim.api.nvim_win_set_cursor(0, { 6, 7 })
	end
	vim.schedule_wrap(_inner_update)()
end

function CommentLine:deactivate(autocmd_callback_data)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local new_line = utility.get_line(cursor_pos[1])
	return new_line:sub(1, 2) == "--"
end

return CommentLine
