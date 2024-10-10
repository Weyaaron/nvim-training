local renderer = {}

local layout_index = require("nvim-training.layouts.layout_index")
local user_config = require("nvim-training.user_config")

function renderer.store_key_value_in_display_to_be_rendered(key, value)
	layout_index[user_config.screen_layout].values[key] = value
end

function renderer.render()
	local template = layout_index[user_config.screen_layout].template
	for key, el in pairs(layout_index[user_config.screen_layout].values) do
		template = string.gsub(template, key, el)
	end

	local utility = require("nvim-training.utility")
	local str_as_lines = utility.split_str(template, "\n")

	if #str_as_lines[1] == 0 then
		str_as_lines = table.unpack(str_as_lines, 2, #str_as_lines)
	end

	local nonempty_lines = {}
	for i, v in pairs(str_as_lines) do
		if #v > 0 then
			nonempty_lines[#nonempty_lines + 1] = v
		end
	end

	if user_config.layout_options.allow_empty_lines then
		nonempty_lines = str_as_lines
	end
	vim.api.nvim_buf_set_lines(0, 0, #nonempty_lines, false, nonempty_lines)
	vim.cmd("sil write!")
	-- layout_index[user_config.screen_layout].values = {}
end

return renderer
