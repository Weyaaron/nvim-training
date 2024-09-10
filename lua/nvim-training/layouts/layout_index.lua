local basic_layout_values = {
	_h = "Status",
	_s_ = 0,
	_f_ = 0,
	_d_ = "Empty Description",
	_streak_ = 0,
	_maxstreak_ = 0,
	_prefix_ = "",
	_suffix_ = "",
	_middle_str_ = "",
}
local basic_layout =
	"_prefix_------_h-------\nYour next Task: _d_\nSuccesses: _s_, Failures: _f_\nCurrent Streak: _streak_ Your best Streak: _maxstreak_\n_middle_str_\n --------------_suffix_"

local minimal_layout_values = {
	_h = "Status",
	_d_ = "Empty Description",
	_prefix_ = "",
	_suffix_ = "",
	_middle_str_ = "",
}
local minimal_template = "_d_\n_middle_str_\n"

local minimal = { name = "minimal", values = minimal_layout_values, template = minimal_template }

local basic = { name = "basic", values = basic_layout_values, template = basic_layout }
return { basic = basic, minimal = minimal }
