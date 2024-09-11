local module = {}

function module.parse_into_root()
	local parser = vim.treesitter.get_parser(0, "lua")
	local tree = parser:parse({ 1, 100 })[1]
	return tree:root()
end

function module.parse_func_start_indexes(root)
	local query = vim.treesitter.query.parse("lua", "(function_declaration)@f")
	local start_indexes = {}
	local end_indexes = {}
	for pattern, match, metadata in query:iter_matches(root, 0) do
		for id, node in pairs(match) do
			local name = query.captures[id]
			start_indexes[#start_indexes + 1] = { node:start() }
			end_indexes[#end_indexes + 1] = { node:end_() }
		end
	end

	local result = {}

	for key, value in pairs(start_indexes) do
		result[#result + 1] = { start_indexes[key], end_indexes[key] }
	end
	return result
end

return module
