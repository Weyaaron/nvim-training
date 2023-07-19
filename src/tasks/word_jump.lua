local jump_word_task = { desc = "Jump words", autocmds = { "CursorMoved" }, minimal_level = 1 }
local data = { previous_cursor_position = 0, cursor_target = 0, highlight_namespace = nil }
local utility = require("src.utility")
local buffer_data = utility.read_buffer_source_file("./buffer_data/test.buffer")

function jump_word_task.init()
	utility.replace_main_buffer_with_str(buffer_data["initial_buffer"])
	--vim.api.nvim_win_set_cursor(0, buffer_data["cursor_position"])

	local cursor_position_tuple = vim.api.nvim_win_get_cursor(0)
	local current_line_index = cursor_position_tuple[1] - 1
	local current_y_cursor_index = cursor_position_tuple[2]

	local current_line = vim.api.nvim_buf_get_lines(0, current_line_index, current_line_index + 1, false)[1]
	current_line = string.sub(current_line, current_y_cursor_index)
	--print(current_line)

	local jump_target_offset_in_words = math.random(2, 5)

	local cursor_offset_in_chars = 0
	local words_in_line = utility.split_str(current_line, " ")

	local word_lengths = {}

	--This function breaks on multiple whitespaces between words
	for i = 1, jump_target_offset_in_words + 1 do
		if string.len(words_in_line[i]) > 0 then
			local current_word_length = string.len(words_in_line[i]) + 1
			word_lengths[i] = current_word_length
			cursor_offset_in_chars = cursor_offset_in_chars + current_word_length
		end
	end

	local count_list = ""

	for i, v in pairs(word_lengths) do
		count_list = count_list .. tostring(v) .. ", "
	end
	print(count_list)

	--print(tostring(jump_target_offset_in_words) .. ":" .. tostring(cursor_offset_in_chars))

	jump_word_task.desc = "Jump " .. tostring(jump_target_offset_in_words) .. " words relative to your cursor."
	jump_word_task.desc = tostring(jump_target_offset_in_words) .. ":" .. tostring(cursor_offset_in_chars)

	data.highlight_namespace = vim.api.nvim_create_namespace("JumpWordLineNameSpace")

	vim.api.nvim_set_hl(0, "UnderScore", { underline = true })

	local left_hl_bound = current_y_cursor_index + cursor_offset_in_chars
	data.cursor_target = left_hl_bound

	vim.api.nvim_buf_add_highlight(
		0,
		data.highlight_namespace,
		"UnderScore",
		current_line_index,
		left_hl_bound,
		left_hl_bound + 1
	)
end

function jump_word_task.failed()
	local current_y_cursor_index = vim.api.nvim_win_get_cursor(0)[2]

	local diff = data.cursor_target - current_y_cursor_index
	print("Diff:" .. tostring(diff))

	return diff == 0
end

function jump_word_task.completed()
	return not jump_word_task.failed()
end

function jump_word_task.teardown()
	if data.highlight_namespace then
		vim.api.nvim_buf_clear_namespace(0, data.highlight_namespace, 0, -1)
	end
end

return jump_word_task
