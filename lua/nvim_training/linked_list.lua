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
	--print("Traversing" ..self.content)
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
		local x_comparison = input_node.line_index == line_index
		local left_bound = (input_node.start_index <= char_index)
		local right_bound = (input_node.end_index >= char_index)
		local status = input_node.content
			.. " "
			.. tostring(x_comparison)
			.. " "
			.. tostring(left_bound)
			.. " "
			.. tostring(right_bound)
		--print(status)

		return x_comparison and left_bound and right_bound
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
		counter = counter + 1
		return counter == distance
	end
	return self:traverse(inner_traverse)
end

function LinkedListNode:w(offset)
	return self:traverse_n(offset)
end
function LinkedListNode:test()
	return { self.next }
end

--This function has to deviate from the default return value
--by returning the offset since the offset is required in the ui
function LinkedListNode:e(cursor_x, cursor_y, offset)
	local offset_to_end = (cursor_y - self.end_index) + 2
	print("Offset at node " .. self.content .. " is " .. offset_to_end)
	--print("Starting at " .. self.content)
	if offset_to_end == 0 then
		offset = offset - 1
	end
	return { self:traverse_n(offset), offset }
end

function LinkedListNode:f(target_char)
	return self:_traverse_until_char(target_char)
end

function LinkedListNode:search(target_str)
	local function traverse_by_content(input_node)
		return input_node.content == target_str
	end
	return self:traverse(traverse_by_content)
end

function LinkedListNode:_traverse_until_char(target_char)
	local utility = require("lua.nvim_training.utility")
	local function traverse_to_char(input_node)
		local search_result = utility.search_for_char_in_word(input_node.content, target_char)
		return not (search_result == -1)
	end
	return self:traverse(traverse_to_char)
end
function LinkedListNode:t(target_char)
	print("Starting at " .. self.content)
	local result = self:_traverse_until_char(target_char)
	print("moved from " .. self.content .. " and input " .. target_char .. " to " .. result.content)
	return result
end
return LinkedListNode
