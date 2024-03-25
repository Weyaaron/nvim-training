-- luacheck: globals vim

local header = {}

local utility = require("nvim-training.utility")
local current_config = require("nvim-training.current_config")
local header_values = { _h = "Status", _s_ = 0, _f_ = 0, _d_ = "Empty Description", _streak_ = 0, _maxstreak_ = 0 }
local initial_header =
	"------_h-------\nYour next Task: _d_\nSuccesses: _s_, Failures: _f_\nCurrent Streak: _streak_ Your best Streak: _maxstreak_\n--------------"

function header.clear_highlight(highlight_obj)
	vim.api.nvim_buf_clear_namespace(0, highlight_obj.highlight_namespace, 0, -1)
end

function header.store_key_value_in_header(key, value)
	header_values[key] = value
end

function header.construct_header()
	local constructed_header = initial_header

	for key, el in pairs(header_values) do
		constructed_header = string.gsub(constructed_header, key, el)
	end
	local str_as_lines = utility.split_str(constructed_header, "\n")

	vim.api.nvim_buf_set_lines(0, 0, current_config.header_length, false, str_as_lines)
end

return header
