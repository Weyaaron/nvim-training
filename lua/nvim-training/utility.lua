local internal_config = require("nvim-training.internal_config")
local template_index = require("nvim-training.template_index")
local user_config = require("nvim-training.user_config")
local utility = {}

function utility.validate_custom_collections()
	local task_index = require("nvim-training.task_index")
	local collection_index = require("nvim-training.task_collection_index")
	for i, collection_name in pairs(user_config.custom_collections) do
		if collection_index[collection_name] then
			print(collection_name .. "overrides a build-in collection! This is supported but not encouraged.")
		end
	end
	for i, collection_el in pairs(user_config.custom_collections) do
		for ii, name_el in pairs(collection_el) do
			if task_index[name_el] == nil then
				print(
					"Unable to resolve task name '"
						.. name_el
						.. "' contained in custom collection '"
						.. i
						.. "'. It will be ignored."
				)
			end
			collection_el[ii] = nil
		end
	end
end

function utility.do_f_preparation(line, f_movement, target_char)
	utility.set_buffer_to_rectangle_with_line(line)

	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	vim.api.nvim_win_set_cursor(0, { cursor_pos[1], utility.calculate_center_cursor_pos() })

	cursor_pos = vim.api.nvim_win_get_cursor(0)
	local new_x_pos = f_movement(line, cursor_pos[2], target_char)
	local cursor_target = { cursor_pos[1], new_x_pos }

	utility.construct_highlight(cursor_target[1], cursor_target[2], 1)
	return cursor_target
end

function utility.extract_text_right_to_left(line, left, right)
	local result = line:sub(left + 1, right)
	return result
end

function utility.extract_text_left_to_right(line, left, right)
	local result = line:sub(left + 1, right + 1)
	return result
end

function utility.replace_content_in_md(original_content, new_content, boundary_counter)
	local start_index, start_end_index = string.find(original_content, "<!-- s" .. boundary_counter .. " -->", 1, true)
	local end_index, end_end_index = string.find(original_content, "<!-- e" .. boundary_counter .. " -->", 1, true)
	local prefix = original_content:sub(1, start_end_index)
	local suffix = original_content:sub(end_index, #original_content)

	return prefix .. new_content .. "\n" .. suffix
end

function utility.calculate_center_cursor_pos()
	local boundary_size = 3
	local lower_pos_bound = math.floor(internal_config.line_length / 2) - boundary_size
	local higher_pos_bound = math.floor(internal_config.line_length / 2) + boundary_size
	return math.random(lower_pos_bound, higher_pos_bound)
end

function utility.check_for_file_existence(file)
	if not file then
		return false
	end
	local ok, err, code = os.rename(file, file)
	if not ok then
		if code == 13 then
			-- Permission denied, but it exists
			return true
		end
	end
	return ok
end

local function construct_word_hls(counter, word_boundary_detection_method)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local line = utility.get_line(cursor_pos[1])
	local word_bounds = word_boundary_detection_method(line)
	local hl_counter = 0
	for i, v in pairs(word_bounds) do
		if cursor_pos[2] > v[1] and cursor_pos[2] < v[2] then
			utility.construct_highlight(cursor_pos[1], cursor_pos[2], math.abs(cursor_pos[2] - v[2]))
		end

		if v[1] > cursor_pos[2] and hl_counter < counter - 1 then
			hl_counter = hl_counter + 1
			utility.construct_highlight(cursor_pos[1], v[1], math.abs(v[1] - v[2]))
		end
	end
end

function utility.construct_word_hls_forwards(counter)
	return construct_word_hls(counter, utility.calculate_word_bounds)
end

function utility.construct_WORD_hls_forwards(counter)
	return construct_word_hls(counter, utility.calculate_WORD_bounds)
end
function utility.construct_char_line(target_char, target_index)
	local char_values = { "x", "y", "z" }
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
			line = line .. char_values[(i % 3) + 1]
		end
	end
	return line
end

--Todo: Remove from codebase and replace with word construction
function utility.load_random_line()
	local lorem_ipsum = utility.load_line_template(template_index.LoremIpsum)
	local lorem_lines = utility.split_str(lorem_ipsum, "\n")
	--The last line is cut, we want to avoid running into it if possible -> -1
	return lorem_lines[math.random(#lorem_lines - 1)]
end

function utility.trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end
function utility.calculate_target_char()
	local target_char_index = math.random(#user_config.task_alphabet)
	return user_config.task_alphabet:sub(target_char_index, target_char_index)
end

function utility.construct_register_description(register_char)
	if register_char == '"' then
		return ""
	else
		return " into register '" .. register_char .. "'"
	end
end

function utility.calculate_target_register()
	if user_config.enable_registers then
		return user_config.possible_register_list[math.random(#user_config.possible_register_list)]
	end
	return '"'
end

function utility.calculate_counter()
	local counter = 1
	if user_config.enable_counters then
		counter = math.random(user_config.counter_bounds[1], user_config.counter_bounds[2])
	end
	return counter
end

function utility.set_buffer_to_lorem_ipsum_and_place_cursor_randomly()
	utility.update_buffer_respecting_header(utility.load_line_template(template_index.LoremIpsum))

	local line_count = vim.api.nvim_buf_line_count(0)
	local rand_line_index = math.random(internal_config.header_length + 1, line_count - 1)
	local y = math.random(0, #utility.get_line(rand_line_index))
	vim.api.nvim_win_set_cursor(0, { rand_line_index, y })
end

function utility.set_buffer_to_rectangle_with_line(middle_line)
	utility.update_buffer_respecting_header(utility.load_rectangle_with_line(middle_line))
	local x = internal_config.header_length + 4

	local y = math.random(0, #utility.get_line(x))
	vim.api.nvim_win_set_cursor(0, { x, y })
end

function utility.construct_data_search(word_length, left_target_bound, right_target_bound)
	local base_chars = "abcedefhikjlmnABCDEFGDHIK"
	local target_string = ""
	for i = 1, word_length, 1 do
		local index = math.random(#base_chars)
		target_string = target_string .. base_chars:sub(index, index)
	end
	--Todo: Do not allow short words! And make sure the word is the first search result.
	-- Todo: Add word random bounds to method to allow backward search in the same method
	local initial_line = utility.construct_words_line()

	-- local target_pos = math.random(25, #initial_line)
	local target_pos = math.random(left_target_bound, right_target_bound)

	local new_line = initial_line:sub(1, target_pos)
		.. " "
		.. target_string
		.. " "
		.. initial_line:sub(target_pos, #initial_line)

	return { new_line, target_string, target_pos + 1 }
end

function utility.get_keys(t)
	local keys = {}
	for key, _ in pairs(t) do
		keys[#keys + 1] = key
	end
	return keys
end

function utility.truth_table(t)
	local keys = {}
	for key, value in pairs(t) do
		keys[value] = true
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

function utility.construct_random_quote_pair()
	local quote = user_config.quotes[math.random(#user_config.quotes)]
	return { quote, quote }
end
function utility.construct_random_bracket_pair()
	return user_config.bracket_pairs[math.random(#user_config.bracket_pairs)]
end

function utility.construct_highlight(x, y, len)
	if user_config.enable_highlights then
		vim.api.nvim_set_hl(0, "UnderScore", { underline = true })
		vim.api.nvim_buf_add_highlight(0, internal_config.global_hl_namespace, "UnderScore", x - 1, y, y + len)
	end
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
	local bounds_from_regex = calculate_text_piece_bounds(input_str, match_strs)

	local result = {}
	for i = 1, #bounds_from_regex, 1 do
		--The regex result is one character to long. Fixing it this way is easier then messing with the regex.
		result[#result + 1] = { bounds_from_regex[i][1], bounds_from_regex[i][2] - 1 }
	end

	return result
end

function utility.calculate_word_bounds(input_str) -- { start_index, end_index}, 0-indexed
	-- words as consequent groups of alphanumeric chars with underline '_', the second matches match . and , respectivly
	local match_strs = { "()([%w_]+)()", "()(%.)()", "()(,)()" }
	return calculate_text_piece_bounds(input_str, match_strs)
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

function utility.get_line(index)
	return vim.api.nvim_buf_get_lines(internal_config.buf_id, index - 1, index, true)[1]
end

function utility.update_buffer_respecting_header(input_str)
	local str_as_lines = utility.split_str(input_str, "\n")
	vim.api.nvim_buf_set_lines(
		internal_config.buf_id,
		internal_config.header_length,
		internal_config.buffer_length,
		false,
		{}
	)

	local end_index = internal_config.header_length + #str_as_lines
	vim.api.nvim_buf_set_lines(internal_config.buf_id, internal_config.header_length, end_index, false, str_as_lines)
end

function utility.append_lines_to_buffer(input_str)
	local str_as_lines = utility.split_str(input_str, "\n")
	local buf_len = vim.api.nvim_buf_line_count(0)
	vim.api.nvim_buf_set_lines(internal_config.buf_id, buf_len, buf_len + #str_as_lines, false, str_as_lines)
end

function utility.split_str(input, sep)
	if not input then
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

function utility.load_line_template(template_content)
	local lines = {}

	local template_as_line = string.gsub(template_content, "\n", " ")
	for i = 1, #template_as_line, internal_config.line_length do
		local current_text = string.sub(template_as_line, i, i + internal_config.line_length)
		lines[#lines + 1] = current_text
	end
	return table.concat(lines, "\n")
end

function utility.load_raw_template(template_content)
	return template_content
end

function utility.load_rectangle_with_line(middle_line)
	local rectange_template = utility.load_line_template(template_index.Rectangle)
	local rectangle_lines = utility.split_str(rectange_template, "\n")
	--The last line is cut, we want to avoid running into it if possible -> -1

	local result = { rectangle_lines[1], "\n", middle_line, "\n", utility.trim(rectangle_lines[2]) }
	return table.concat(result, "\n")
end

function utility.gather_tags(tasks)
	local result = {}
	for i, task_el in pairs(tasks) do
		for ii, tag_el in pairs(task_el.metadata.tags) do
			result[tag_el] = tag_el
		end
	end
	return result
end

function utility.flatten(input_table, resulting_table)
	if type(input_table) ~= "table" then
		return input_table
	end

	if resulting_table == nil then
		resulting_table = {}
	end

	for i, outer_table_el in pairs(input_table) do
		if type(outer_table_el) == "table" then
			local recursive_result = utility.flatten(outer_table_el, {})
			for ii, inner_table_el in pairs(recursive_result) do
				resulting_table[#resulting_table + 1] = inner_table_el
			end
		else
			resulting_table[#resulting_table + 1] = outer_table_el
		end
	end
	return resulting_table
end

function utility.create_task_list_with_given_tags(tag_list)
	local task_index = require("nvim-training.task_index")
	local tasks_with_tag = {}
	for i, tag_el in pairs(tag_list) do
		for ii, task_el in pairs(task_index) do
			for iii, inner_tag_el in pairs(task_el.metadata.tags) do
				if tag_el == inner_tag_el then
					tasks_with_tag[#tasks_with_tag + 1] = ii
				end
			end
		end
	end

	tasks_with_tag = utility.remove_duplicates_from_iindex_based_table(tasks_with_tag)
	return tasks_with_tag
end

function utility.append_to_table_path(data, path)
	--Has been temorarily disabled to fix a design flaw
	-- if user_config.enable_events then
	-- 	utility.append_json_to_file(path, data)
	-- end
end

-- function utility.append_json_to_file(path, data)
--
-- 	--Has been temorarily disabled to fix a design flaw
-- 	-- local file = io.open(path, "a")
-- 	--
-- 	-- table.sort(data)
-- 	--
-- 	-- local data_as_str = vim.json.encode(data)
-- 	--
-- 	-- file:write(data_as_str .. "\n")
-- 	-- file:close()
-- end
function utility.apppend_table_to_path(data, path)
	if user_config.enable_events then
		utility.append_json_to_file(path, data)
	end
end

function utility.append_json_to_file(path, data)
	local file = io.open(path, "a")

	local data_as_str = vim.json.encode(data)

	file:write(data_as_str .. "\n")
	file:close()
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
	local paths = utility.scandir(user_config.event_storage_directory_path)
	local result = {}
	for i, v in pairs(paths) do
		local file = io.open(user_config.event_storage_directory_path .. "/" .. v, "r")

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
	local base_template = utility.load_line_template(template_name)
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

function utility.construct_empty_line_with_new_line()
	local result = ""
	for i = 1, internal_config.line_length do
		result = result .. " "
	end
	result = result .. "\n"
	return result
end

function utility.remove_duplicates_from_iindex_based_table(input_table)
	local output_table = {}
	local hash_table = {}
	for i, v in pairs(input_table) do
		if not hash_table[v] then
			output_table[#output_table + 1] = v
			hash_table[v] = true
		end
	end
	return output_table
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
