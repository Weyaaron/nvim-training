local text_traversal = {}

function text_traversal.construct_index_table_from_text_lines(lines)
	local result = {}
	for i = 1, #lines do
		for ii = 1, #lines[i] do
			local current_char = string.sub(lines[i], ii, ii)
			result[#result + 1] = { current_char, i, ii }
		end
	end
	return result
end

function text_traversal.traverse_to_x_y(char_list, x, y)
	while not (#char_list == 0) do
		local x_match = char_list[1][2] == x
		local y_match = char_list[1][3] == y

		if x_match and y_match then
			break
		end
		char_list = { unpack(char_list, 2, #char_list) }
	end

	return char_list
end
function text_traversal.print_list(char_list)
	for i = 1, #char_list do
		print(char_list[i][1], char_list[i][2], char_list[i][3])
	end
end
function text_traversal.traverse_to_next_char(char_list, char)
	while not (#char_list == 0) do
		local first_char_matches = char_list[1][1] == char
		if first_char_matches then
			break
		end
		char_list = { unpack(char_list, 2, #char_list) }
	end
	return char_list
end

function text_traversal.traverse_n_words(char_list, n)
	local start_chars = ""
	for i = 1, n + 1 do
		local current_line = char_list[1][2]
		char_list = text_traversal.traverse_to_next_char(char_list, " ")
		--We have to discard the whitespace. Todo: Work with multiple whitespaces!
		char_list = { unpack(char_list, 2, #char_list) }

		start_chars = start_chars .. char_list[1][1]
		local new_line = char_list[1][2]
		if not (new_line == current_line) then
			i = i + 1
			-- print("Moved lines", current_line, new_line)
		end
	end
	print(start_chars)

	return char_list
end

return text_traversal
