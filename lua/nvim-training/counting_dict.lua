local CountingDict = {}
CountingDict.__index = CountingDict

function CountingDict:new(args)
	local base = args or {}
	setmetatable(base, { __index = self })
	base.container = {}
	return base
end

function CountingDict:add(new_el)
	if self.container[new_el] then
		self.container[new_el] = self.container[new_el] + 1
	end
end

function CountingDict:count(el_to_be_counted)
	return self.container[el_to_be_counted]
end

return CountingDict
