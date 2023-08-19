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

function LinkedListNode:stringify()
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
	return desc .. " " .. self.next:stringify()
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
	local current_node = condition_fn(self)
	if current_node then
		return self
	end
	if self.previous then
		return self.previous:backtrack(condition_fn)
	end
	return nil
end

function LinkedListNode:traverse_to_line_char(line_index, char_index)
	char_index = char_index + 1

	local function traversal_function(input_node)
		local x_comparision = input_node.line_index == line_index
		local left_bound = (input_node.start_index <= char_index)
		local right_bound = (input_node.end_index >= char_index)
		print(
			input_node.content
				.. " "
				.. tostring(x_comparision)
				.. " "
				.. tostring(left_bound)
				.. " "
				.. tostring(right_bound)
		)

		return x_comparision and left_bound and right_bound
	end

	return self:traverse(traversal_function)
end

function LinkedListNode:traverse_and_consume(stop_func)
	local current_status = stop_func(self)
	if not current_status then
		if self.previous then
			self.previous.next = self.next
		end
		return self.next:traverse_and_consume(self.next, stop_func)
	else
		return self
	end
end
function LinkedListNode:traverse_n(distance)
	local counter = 0
	local function inner_traverse(input_node)
		counter = counter + 1
		return counter == distance
	end
	return self:traverse(inner_traverse)
end
return LinkedListNode
