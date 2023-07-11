




absolute_line_task ={desc= 'Move to line relative to ', success='Wuhu!'}
local data = {target_line= 0}

function absolute_line_task.init()

	data.target_line = math.random(1,15)
	absolute_line_task.desc = 'Move to line ' ..  tostring(data.target_line)
	print('Target line ' .. tostring(data.target_line))

end

function absolute_line_task.check()
	local cursor_position = vim.api.nvim_win_get_cursor(0)[1]
	local comparison = cursor_position == data.target_line
	print('Target line after check ' .. tostring(data.target_line))
	return comparison

end
    function absolute_line_task.teardown()

end

return absolute_line_task