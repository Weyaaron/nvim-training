local Node = {}
Node.__index = Node

function Node:new(content, line_index, start_index, end_index)
	self.__index = self
	local base = {}
	setmetatable(base, self)
	base.content = content
	base.line_index = line_index
	base.start_index = start_index
	base.end_index = end_index

	return base
end

function Node:stringify()
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
function Node:traverse(condition_fn)
	local current_node = condition_fn(self)
	if current_node then
		return self
	end
	if self.next then
		return self.next:traverse(condition_fn)
	end
	return nil
end

function Node:backtrack(condition_fn)
	local current_node = condition_fn(self)
	if current_node then
		return self
	end
	if self.previous then
		return self.previous:backtrack(condition_fn)
	end
	return nil
end

return Node
