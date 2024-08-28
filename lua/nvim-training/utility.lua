local internal_config = require("nvim-training.internal_config")
local template_index = require("nvim-training.template_index")
local user_config = require("nvim-training.user_config")
local utility = {}

function utility.exists(file)
	local ok, err, code = os.rename(file, file)
	if not ok then
		if code == 13 then
			-- Permission denied, but it exists
			return true
		end
	end
	return ok, err
end

function utility.isdir(path)
	return utility.exists(path .. "/")
end

function utility.construct_char_line(target_char, target_index)
	local line = ""
	for i = 1, internal_config.line_length do
		local is_target_or_space = false
		if i == target_index then
			line = line .. target_char
			is_target_or_space = true
		end
		if i == target_index + 1 or i == target_index - 1 then
			line = line .. " "
			is_target_or_space = true
		end
		if not is_target_or_space then
			line = line .. "x"
		end
	end
	return line
end
function utility.trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end
function utility.calculate_target_char()
	local target_char_index = math.random(#user_config.task_alphabet)
	return user_config.task_alphabet:sub(target_char_index, target_char_index)
end
function utility.calculate_counter()
	local counter = 1
	if user_config.enable_counters then
		counter = math.random(user_config.counter_bounds[1], user_config.counter_bounds[2])
	end
	return counter
end

function utility.get_current_line()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	return utility.get_line(cursor_pos[1])
end
function utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()
	utility.update_buffer_respecting_header(utility.load_template(template_index.LoremIpsum))
	utility.move_cursor_to_random_point()
end
function utility.set_buffer_to_rectangle_and_place_cursor_randomly()
	local lorem_ipsum = utility.load_template(template_index.LoremIpsum)
	local lorem_lines = utility.split_str(lorem_ipsum, "\n")
	--The last line is cut, we want to avoid running into it if possible -> -1
	local random_line = lorem_lines[math.random(#lorem_lines - 1)]

	utility.update_buffer_respecting_header(utility.load_rectangle_with_line(random_line))
	local x_pos = internal_config.header_length + 4
	local y = utility.random_col_index_at(x_pos)
	vim.api.nvim_win_set_cursor(0, { x_pos, y })
end

function utility.set_buffer_to_rectangle_with_line(middle_line)
	utility.update_buffer_respecting_header(utility.load_rectangle_with_line(middle_line))
	local x_pos = internal_config.header_length + 4
	local y = utility.random_col_index_at(x_pos)
	vim.api.nvim_win_set_cursor(0, { x_pos, y })
end

function utility.get_keys(t)
	local keys = {}
	for key, _ in pairs(t) do
		table.insert(keys, key)
	end
	return keys
end

function utility.construct_line_with_bracket(bracket_pair, left_index, right_index)
	local result = ""
	for i = 1, internal_config.line_length do
		if i < left_index then
			result = result .. " "
		end
		if i == left_index then
			result = result .. bracket_pair[1]
		end

		if i > left_index and i < right_index then
			result = result .. "x"
		end
		if i == right_index then
			result = result .. bracket_pair[2]
		end
	end
	return result
end

function utility.create_highlight(x, y, len)
	vim.api.nvim_set_hl(0, "UnderScore", { underline = true })
	vim.api.nvim_buf_add_highlight(0, internal_config.global_hl_namespace, "UnderScore", x, y, y + len)
end

function utility.move_cursor_to_random_point()
	vim.api.nvim_win_set_cursor(0, utility.calculate_random_point_in_text_bounds())
end

function utility.select_random_word_bounds_at_line(i)
	local line = utility.get_line(i)
	local word_params = utility.calculate_word_bounds(line)
	return word_params[math.random(1, #word_params)]
end

function utility.calculate_random_point_in_text_bounds()
	local x = utility.random_line_index()
	local y = utility.random_col_index_at(x)
	return { x, y }
end

function utility.calculate_random_point_in_line_bound(x)
	local y = utility.random_col_index_at(x)
	return { y }
end

local function calculate_text_piece_bounds(input_str, patterns) -- { start_index, end_index}, 0-indexed
	local pieces = {}

	for i, pattern_el in pairs(patterns) do
		for start, _, finish in input_str:gmatch(pattern_el) do
			pieces[#pieces + 1] = { start - 1, finish - 1 }
		end
	end

	table.sort(pieces, function(a, b)
		return a[1] < b[1]
	end)

	return pieces
end

function utility.calculate_WORD_bounds(input_str) -- { start_index, end_index}, 0-indexed
	--Defined as non-whitespace characters surrounded by whitespace
	local match_strs = { "()%s*(%S+)%s*()" }
	return calculate_text_piece_bounds(input_str, match_strs)
end

function utility.calculate_word_bounds(s) -- { start_index, end_index}, 0-indexed
	-- words as consequent groups of alphanumeric chars with underline '_', the second matches match . and , respectivly
	local match_strs = { "()([%w_]+)()", "()(%.)()", "()(,)()" }
	return calculate_text_piece_bounds(s, match_strs)
end

function utility.calculate_word_index_from_cursor_pos(word_bounds, cursor_pos)
	local index = 0
	for i, v in pairs(word_bounds) do
		local word_start = v[1]
		local word_end = v[2]
		if cursor_pos <= word_end and cursor_pos >= word_start then
			index = i
		end
	end
	return index
end

function utility.random_line_index()
	local line_count = vim.api.nvim_buf_line_count(0)
	return math.random(internal_config.header_length + 1, line_count - 1)
end

function utility.get_line(index)
	return vim.api.nvim_buf_get_lines(0, index - 1, index, true)[1]
end

function utility.random_col_index_at(index)
	return math.random(0, #utility.get_line(index))
end

function utility.clear_all_our_highlights()
	vim.api.nvim_buf_clear_namespace(0, internal_config.global_hl_namespace, 0, -1)
end

function utility.update_buffer_respecting_header(input_str)
	local str_as_lines = utility.split_str(input_str, "\n")
	vim.api.nvim_buf_set_lines(0, internal_config.header_length, internal_config.buffer_length, false, {})

	local end_index = internal_config.header_length + #str_as_lines
	vim.api.nvim_buf_set_lines(0, internal_config.header_length, end_index, false, str_as_lines)
	vim.cmd("sil write!")
end

function utility.append_lines_to_buffer(input_str)
	local str_as_lines = utility.split_str(input_str, "\n")
	local buf_len = vim.api.nvim_buf_line_count(0)
	vim.api.nvim_buf_set_lines(0, buf_len, buf_len + #str_as_lines, false, str_as_lines)
	vim.cmd("sil write!")
end

function utility.split_str(input, sep)
	if not input then
		print("No input")
		return {}
	end
	if not sep then
		sep = "\n"
	end

	assert(type(input) == "string" and type(sep) == "string", "The arguments must be <string>")
	if sep == "" then
		return { input }
	end

	local res, from = {}, 1
	repeat
		local pos = input:find(sep, from)
		res[#res + 1] = input:sub(from, pos and pos - 1)
		from = pos and pos + #sep
	until not from
	if #res == 0 then
		return { input }
	end
	return res
end

function utility.load_template(template_path)
	local lines = {}

	local template_as_line = string.gsub(template_path, "\n", " ")
	for i = 1, #template_as_line, internal_config.line_length do
		local current_text = string.sub(template_as_line, i, i + internal_config.line_length)
		lines[#lines + 1] = current_text
	end
	return table.concat(lines, "\n")
end

function utility.load_rectangle_with_line(middle_line)
	local rectange_template = utility.load_template(template_index.Rectangle)
	local rectangle_lines = utility.split_str(rectange_template, "\n")
	--The last line is cut, we want to avoid running into it if possible -> -1

	local result = { rectangle_lines[1], "\n", middle_line, "\n", rectangle_lines[2] }

	return table.concat(result, "\n")
end

function utility.gather_tags(tasks)
	local result = {}
	for i, task_el in pairs(tasks) do
		local current_tag = task_el.__metadata.tags or ""
		local current_pieces = utility.split_str(current_tag, ", ")
		for ii, tag_el in pairs(current_pieces) do
			result[tag_el] = tag_el
		end
	end
	return result
end

function utility.filter_tasks_by_tags(tasks, tag_list)
	local tasks_with_tag = {}
	for i, tag_el in pairs(tag_list) do
		for ii, task_el in pairs(tasks) do
			local current_tag = task_el.__metadata.tags or ""
			if current_tag:find(tag_el) then
				tasks_with_tag[#tasks_with_tag + 1] = ii
			end
		end
	end
	return tasks_with_tag
end

function utility.discard_tasks_by_tags(tasks, tag_list)
	local tasks_with_tag = {}
	for i, tag_el in pairs(tag_list) do
		for ii, task_el in pairs(tasks) do
			local current_tag = task_el.__metadata.tags or ""
			if current_tag:find(tag_el) == nil then
				tasks_with_tag[#tasks_with_tag + 1] = ii
			end
		end
	end
	return tasks_with_tag
end

function utility.extract_text_between_cursor_and_target(start_indexes, end_indexes) end

function utility.apppend_table_to_path(data, path)
	if user_config.enable_events then
		local file = io.open(path, "a")

		table.sort(data)

		local data_as_str = vim.json.encode(data)

		file:write(data_as_str .. "\n")
		file:close()
	end
end

function utility.uuid()
	math.randomseed(os.time())
	local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
	return string.gsub(template, "[xy]", function(c)
		local v = (c == "x") and math.random(0, 0xf) or math.random(8, 0xb)
		return string.format("%x", v)
	end)
end

function utility.scandir(directory)
	local i, t, popen = 0, {}, io.popen
	local pfile = popen('ls "' .. directory .. '"')
	for filename in pfile:lines() do
		i = i + 1
		t[i] = filename
	end
	pfile:close()
	return t
end

function utility.load_all_events()
	local paths = utility.scandir(user_config.base_path)
	local result = {}
	for i, v in pairs(paths) do
		local file = io.open(user_config.base_path .. "/" .. v, "r")

		local data = file:read("a")

		local lines = utility.split_str(data)
		for ii, line_el in pairs(lines) do
			if #line_el > 1 then
				result[#result + 1] = vim.json.decode(line_el)
			end
		end

		file:close()
	end
	return result
end

local function construct_words_line_from_template(template_name)
	local base_template = utility.load_template(template_name)
	base_template = utility.split_str(base_template, "\n")[1]
	local words = utility.split_str(base_template, " ")

	for i = #words, 2, -1 do
		local j = math.random(i)
		words[i], words[j] = words[j], words[i]
	end

	return table.concat(words, " ")
end

function utility.construct_words_line()
	return construct_words_line_from_template(template_index.LoremIpsum)
end

function utility.construct_WORDS_line()
	return construct_words_line_from_template(template_index.LoremIpsumWORDS)
end

function utility.construct_base_path()
	--https://stackoverflow.com/questions/6380820/get-containing-path-of-lua-file
	local function script_path()
		local str = debug.getinfo(2, "S").source:sub(2)
		local initial_result = str:match("(.*/)")
		return initial_result
	end

	local base_path = script_path() .. "../.."
	return base_path
end
function utility.count_similar_events(events, cmp_func)
	local result = {}

	for i, v in pairs(events) do
		local cmp_result = cmp_func(v)
		if not result[cmp_result] then
			result[cmp_result] = 0
		end
		result[cmp_result] = result[cmp_result] + 1
	end
	return result
end

function utility.filter_by_event_type(events, event_type)
	local result = {}

	for i, v in pairs(events) do
		local current_type = v["event"]
		if event_type == current_type then
			result[#result + 1] = v
		end
	end
	return result
end

return utility
