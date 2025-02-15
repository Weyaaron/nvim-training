local module = {}

local function parse_into_root()
	local parser = vim.treesitter.get_parser(0, "lua")
	local tree = parser:parse({ 1, 100 })[1]
	return tree:root()
end

function module.extract_elements_from_query(query_str)
	local root = parse_into_root()

	local query = vim.treesitter.query.parse("lua", query_str)
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
		result[#result + 1] = {
			start = { x = start_indexes[key][1], y = start_indexes[key][2] },
			_end = { x = end_indexes[key][1], y = end_indexes[key][2] },
		}
	end
	return result
end

return module
