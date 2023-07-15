local relative_line_task = { desc = "Move relative to cursor", autocmds = { "CursorMoved" }, minimal_level = 2 }
local data = { previous_line = 0, target_offset = 0, highlight_namespace = nil }

local function calculate_offset()
	local initial_value = math.random(2, 5)
	local multiplier = { 1, -1 }
	return initial_value * multiplier[math.random(1, 2)]
end

function relative_line_task.init()
	local current_offset = calculate_offset()
	data.previous_line = vim.api.nvim_win_get_cursor(0)[1]

	relative_line_task.desc = "Move " .. tostring(current_offset) .. " lines relative to your cursor."

	data.highlight_namespace = vim.api.nvim_create_namespace("RelativeVerticalLineNameSpace")

	vim.api.nvim_set_hl(0, "UnderScore", { underline = true })

	--Todo: Fix this weird highlight, in particular its index
	vim.api.nvim_buf_add_highlight(0, data.highlight_namespace, "UnderScore", 10, 0, -1)
	data.target_offset = current_offset
end

function relative_line_task.failed()
	return not relative_line_task.completed()
end

function relative_line_task.completed()
	local target_line = data.previous_line + data.target_offset
	return vim.api.nvim_win_get_cursor(0)[1] == target_line
end

function relative_line_task.teardown()
	if data.highlight_namespace then
		vim.api.nvim_buf_clear_namespace(0, data.highlight_namespace, 0, -1)
	end
end

return relative_line_task
