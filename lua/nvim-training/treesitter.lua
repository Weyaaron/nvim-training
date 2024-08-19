local module = {}

function module.parse_into_root()
	local parser = vim.treesitter.get_parser(0, "lua")
	local tree = parser:parse({ 1, 100 })[1]
	return tree:root()
end

function module.parse_func_start_indexes(root)

	-- local query = vim.treesitter.query.parse("lua")
end
