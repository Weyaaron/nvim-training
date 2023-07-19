local absolute_line_task = { desc = nil, autocmds = { "CursorMoved" }, minimal_level = 1, abr = "ABLT" }
local data = { target_line = 0, highlight_namespace = nil }

function absolute_line_task.init()
	data.target_line = math.random(1, 15)
	absolute_line_task.desc = "Move to line " .. tostring(data.target_line)
	data.highlight_namespace = vim.api.nvim_create_namespace("AbsoluteVerticalLineNameSpace")

	vim.api.nvim_set_hl(0, "UnderScore", { underline = true })

	vim.api.nvim_buf_add_highlight(0, data.highlight_namespace, "UnderScore", data.target_line - 1, 0, -1)
end

function absolute_line_task.completed()
	local cursor_position = vim.api.nvim_win_get_cursor(0)[1]
	local comparison = cursor_position == data.target_line
	return comparison
end

function absolute_line_task.failed()
	return not absolute_line_task.completed()
end

function absolute_line_task.teardown()
	if data.highlight_namespace then
		vim.api.nvim_buf_clear_namespace(0, data.highlight_namespace, 0, -1)
	end
end

return absolute_line_task
