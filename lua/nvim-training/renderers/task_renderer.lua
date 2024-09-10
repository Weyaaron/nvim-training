local renderer = {}

local layout_index = require("nvim-training.layouts.layout_index")

local current_layout = "basic"

function renderer.store_key_value_in_display_to_be_rendered(key, value)
	layout_index[current_layout].values[key] = value
end

function renderer.render()
	local template = layout_index[current_layout].template
	for key, el in pairs(layout_index[current_layout].values) do
		template = string.gsub(template, key, el)
	end

	local utility = require("nvim-training.utility")
	local str_as_lines = utility.split_str(template, "\n")
	vim.api.nvim_buf_set_lines(0, 0, #str_as_lines, false, str_as_lines)
end

return renderer
