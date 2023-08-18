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

function LinkedList.construct_text_table_from_list() end

return LinkedList
