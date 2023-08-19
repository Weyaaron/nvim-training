local Node = require("lua.nvim_training/node")

local LinkedList = {}
local utility = require("lua.nvim_training.utility")

function LinkedList.create_list_from_text_table(input_list)
	if not input_list then
		print("Empty Input!")
		return nil
	end

	local nodes_in_list = {}
	local root_node = nil

	for i, line_el in pairs(input_list) do
		local pieces = utility.split_str(line_el, " ")
		for pi, piece_el in pairs(pieces) do
			local values = line_el:find(piece_el)
			local new_node = Node:new(piece_el, i, values, values + #piece_el)
			table.insert(nodes_in_list, new_node)
		end
	end

	root_node = nodes_in_list[1]

	for i = 1, #nodes_in_list do
		nodes_in_list[i].next = nodes_in_list[i + 1]
		nodes_in_list[i].previous = nodes_in_list[i - 1]
	end

	return root_node
end

function LinkedList.traverse_to_cursor(input_node)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local x_comparision = input_node.line_index == cursor_pos[1]
	cursor_pos[2] = cursor_pos[2] + 1
	print(cursor_pos[2])
	local left_bound = (input_node.start_index <= cursor_pos[2])
	local right_bound = (input_node.end_index >= cursor_pos[2])
	print(input_node.content .. tostring(x_comparision) .. " " .. tostring(left_bound) .. " " .. tostring(right_bound))

	--print(input_node:stringify())
	return x_comparision and left_bound and right_bound
end

function LinkedList.traverse_and_consume(input_node, stop_func)
	print("Currently travesing " .. input_node.content)
	local current_status = stop_func(input_node)
	if not current_status then
		if input_node.previous then
			print("swap")
			input_node.previous.next = input_node.next
		end
		LinkedList.traverse_and_consume(input_node.next, stop_func)
	else
		return input_node
	end
	return LinkedList.traverse_and_consume(input_node.next, stop_func)
end

function LinkedList.construct_text_table_from_list(result, input_node)
	if not result then
		result = { "" }
	end
	if not input_node then
		return result
	end

	if not input_node.next then
		result[input_node.line_index] = result[input_node.line_index] .. input_node.content
		return result
	end
	print(input_node.line_index .. " " .. input_node.next.line_index)
	print("len: " .. #result)

	local comparision = input_node.line_index == input_node.next.line_index

	if comparision then
		result[input_node.line_index] = result[input_node.line_index] .. input_node.content
		return LinkedList.construct_text_table_from_list(result, input_node.next)
	else
		result[input_node.line_index] = result[input_node.line_index] .. input_node.content
		table.insert(result, "")
		return LinkedList.construct_text_table_from_list(result, input_node.next)
	end
end
function LinkedList.traverse_n(distance)
	local counter = 0
	local function inner_func(input_node)
		counter = counter + 1
		return counter == distance
	end
	return inner_func
end
return LinkedList
--[[
	local result = {}
	local node_table = {}
	local current_node = input_node

	while current_node.next do
		table.insert(node_table, current_node)
		current_node = current_node.next
	end
	local current_line = ""

	for i = 1, #node_table -1 do
		if node_table[i].line_index == node_table[i + 1].line_index then
			current_line = current_line .. node_table[i].content
		else
			table.insert(result, current_line)
			current_line = ""
		end
	end
	return result
--]]
