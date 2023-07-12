
relative_line_task ={desc= 'Move relative to cursor',}
local data = {line_offset= 0, previous_line = 0, highlight_namespace=nil}

local function calculate_offset()

	local initial_value = math.random(0,10)
	local multiplier ={1,-1}
	return initial_value * multiplier[math.random(1,2)]

end

function relative_line_task.init()
	local current_line = vim.api.nvim_win_get_cursor(0)[1]
	data.line_offset = calculate_offset()
	local upper_bound = vim.api.nvim_buf_line_count(0)
	while  current_line +data.line_offset  > 0 and  current_line+ data.line_offset  < upper_bound    do
		data.line_offset = calculate_offset()
	end

	data.line_offset = 5

	relative_line_task.desc = 'Move ' ..  tostring(data.line_offset) ..' lines relative to your cursor.'
    data.previous_line = current_line

	data.highlight_namespace = vim.api.nvim_create_namespace('RelativeVerticalLineNameSpace')

	vim.api.nvim_set_hl(0, 'UnderScore', {underline=true})

	new_highlight = vim.api.nvim_buf_add_highlight(0, data.highlight_namespace,'UnderScore',  data.previous_line +data.line_offset-1, 0, -1)

end

function relative_line_task.check()
	local cursor_position = vim.api.nvim_win_get_cursor(0)[1]
	local comparison = cursor_position == data.previous_line + data.line_offset
	data.previous_line = vim.api.nvim_win_get_cursor(0)[1]

	return comparison

end
    function relative_line_task.teardown()
		if data.highlight_namespace then
			vim.api.nvim_buf_clear_namespace(0, data.highlight_namespace, 0, -1)
		end

	end

return relative_line_task