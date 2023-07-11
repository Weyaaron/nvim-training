




relative_line_task ={desc= 'Move to absolute line', success='Wuhu!'}
local data = {line_offset= 0, previous_line = 0}

function relative_line_task.init()

	data.line_offset = math.random(-10,10)
	local multiplier ={1,-1}
	data.line_offset = data.line_offset * multiplier[math.random(1,2)]
	relative_line_task.desc = 'Move ' ..  tostring(data.line_offset) ..' lines relative to your cursor.'
    data.previous_line = vim.api.nvim_win_get_cursor(0)[1]

end

function relative_line_task.check()
	local cursor_position = vim.api.nvim_win_get_cursor(0)[1]
	local comparison = cursor_position == data.previous_line + data.line_offset
	data.previous_line = vim.api.nvim_win_get_cursor(0)[1]


	return comparison

end
    function relative_line_task.teardown()

end

return relative_line_task