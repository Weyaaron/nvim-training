local LinkedListNode = {}
LinkedListNode.__index = LinkedListNode

function LinkedListNode:new(content, line_index, start_index, end_index)
	self.__index = self
	local base = {}
	setmetatable(base, self)
	base.content = content
	base.line_index = line_index
	base.start_index = start_index
	base.end_index = end_index
	base.next = nil
	base.previous = nil
	return base
end
function LinkedListNode:_stringify()
	local desc = self.content .. "(" .. self.line_index .. "," .. self.start_index .. "," .. self.end_index .. ")"
	if not self.content then
		return "empty content"
	end

	if self == nil then
		return ""
	end
	if self.next == nil then
		return desc
	end
	return desc .. " " .. self.next:_stringify()
end

function LinkedListNode:stringify()
	return self:root():_stringify()
end

function LinkedListNode:traverse(condition_fn)
	local current_node = condition_fn(self)
	if current_node then
		return self
	end
	if self.next then
		return self.next:traverse(condition_fn)
	end
	return nil
end

function LinkedListNode:backtrack(condition_fn)
	local current_status = condition_fn(self)
	if current_status then
		return self
	end
	if self.previous then
		return self.previous:backtrack(condition_fn)
	else
		return self
	end
end

function LinkedListNode:traverse_to_line_char(line_index, char_index)
	--Todo: Can we fix this?
	char_index = char_index + 1

	local function traversal_function(input_node)
		local x_comparision = input_node.line_index == line_index
		local left_bound = (input_node.start_index <= char_index)
		local right_bound = (input_node.end_index >= char_index)
		local status = input_node.content
			.. " "
			.. tostring(x_comparision)
			.. " "
			.. tostring(left_bound)
			.. " "
			.. tostring(right_bound)
		--print(status)

		return x_comparision and left_bound and right_bound
	end

	return self:traverse(traversal_function)
end

function LinkedListNode:traverse_and_consume_inclusive(stop_func)
	local current_status = stop_func(self)
	if not current_status then
		if self.previous then
			self.previous.next = self.next
		end
		if self.next then
			self.next.previous = self.previous
		end
		return self.next:traverse_and_consume_inclusive(stop_func)
	else
		self.next.previous = self.previous
		return self.next
	end
end

function LinkedListNode:consume_up_until_node_inclusive(target_node)
	local function cmp_func(input_node)
		return input_node.content == target_node.content
	end
	return self:traverse_and_consume_inclusive(cmp_func)
end

function LinkedListNode:root()
	local function _end(input_node)
		return input_node == nil
	end
	return self:backtrack(_end)
end
function LinkedListNode:last()
	local function _end(input_node)
		return input_node == nil
	end
	return self:traverse(_end)
end

function LinkedListNode:traverse_n(distance)
	local counter = 0
	local function inner_traverse(input_node)
		--print("Traversing " ..input_node.content.. "with" ..counter )
		local comparison = counter == distance
		counter = counter + 1
		return comparison
	end
	return self:traverse(inner_traverse)
end

function LinkedListNode:w(offset)
	return self:traverse_n(offset - 1)
end
function LinkedListNode:test()
	return { self.next }
end
function LinkedListNode.e(cursor_x, cursor_y, offset)
	--Todo: Implement this!
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local cursor_node = self.buffer_as_list:traverse_to_line_char(cursor_pos[1], cursor_pos[2])
	local target_node = cursor_node:traverse_n(self.offset)
	return { target_node.line_index, target_node.end_index - 2 }
end

return LinkedListNode
--[[
function LinkedListNode.f(input_node, cursor_x, cursor_y, custom_args)
	local cursor_node = self.buffer_as_list:traverse(utility.traverse_to_cursor)

	local function traverse_to_char(input_node)
		local search_result = utility.search_for_char_in_word(input_node.content, self.target_char)
		return not (search_result == -1)
	end

	local final_node = cursor_node:traverse(traverse_to_char)
	local char_offset_in_word = utility.search_for_char_in_word(final_node.content, self.target_char)

	--Todo: Evaluate the -2 and fix it
	return { final_node.line_index, final_node.start_index + char_offset_in_word - 2 }
end

function Movements.search(input_node, cursor_x, cursor_y, custom_args)
	local cursor_position = vim.api.nvim_win_get_cursor(0)
	local cursor_node = self.buffer_as_list:traverse_to_line_char(cursor_position[1], cursor_position[2])

	local target_node = cursor_node:traverse_n(self.offset)

	return { target_node.line_index, target_node.start_index - 1 }
end

function tMovement:_execute_calculation()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local cursor_pos_x = cursor_pos[1]
	local cursor_pos_y = cursor_pos[2]
	local y_target = 0
	local max_line_len = #self.current_line
	for i = cursor_pos_y + 2, max_line_len, 1 do
		local current_char = string.sub(self.current_line, i, i)
		if current_char == self.target_char then
			y_target = i - 1
			break
		end
	end

	return { cursor_pos_x, y_target - 1 }
end
]]
--
