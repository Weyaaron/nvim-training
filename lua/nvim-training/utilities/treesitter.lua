local module = {}

function module.construct_root()
	local parser = vim.treesitter.get_parser(0, "lua")
	local tree = parser:parse({ 1, 100 })[1]
	return tree:root()
end

function module.construct_query(query_str)
	return vim.treesitter.query.parse("lua", query_str)
end

function module.execute_query(query, pattern)
	local root = module.construct_root()

	local row1, col1, row2, col2, text
	for id, node, metadata, match in query:iter_captures(root, 0) do
		text = vim.treesitter.get_node_text(node, 0)
		row1, col1, row2, col2 = node:range() -- range of the capture
		-- ... use the info here ...
	end
	local result
	local is_valid_pattern = false
	if pattern == "start" then
		is_valid_pattern = true
		result = { row1, col1 }
	end
	if pattern == "text" then
		is_valid_pattern = true
		result = text
	end
	if not is_valid_pattern then
		print("No valid pattern, returning nil")
	end
	return result
end

return module
