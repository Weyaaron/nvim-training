local text_traversal = {}

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
	for i = 1, n do
		char_list = text_traversal.traverse_to_next_char(char_list, " ")
		--We have to discard the whitespace we found
		--Todo: Implement multiple Whitespaces
		char_list = { unpack(char_list, 2, #char_list) }
	end

	return char_list
end

local input = { "Hallo Welt ", "Line Zwei Mit allem was dazu gehört" }
local input = { "Eins Zwei Drei Vier Fünf Sechs Sieben" }

local output = text_traversal.construct_index_table_from_text_lines(input)
for i = 1, #output do
	-- print(output[i][1], output[i][2], output[i][3])
end

-- local traversal_result = text_traversal.find_next_char(output, " ")
local next_word = text_traversal.traverse_n_words(output, 3)
local test_for_empty_input = text_traversal.traverse_n_words({}, 3)
local traverse_x_y = text_traversal.traverse_to_x_y(output, 1, 5)
local traverse_x_y = text_traversal.traverse_to_x_y(output, 1, 5)

local test_for_empty_input = text_traversal.traverse_to_next_char({}, "a")
-- print(traverse_x_y[2][1])
-- print(next_word[1][1])

-- print(output[next_word][1], output[next_word][2], output[next_word][3])

assert = require("luassert")

assert.True(true)
assert.is.True(true)
assert.is_true(true)
assert.is_not.True(false)
assert.is.Not.True(false)
assert.is_not_true(false)
assert.are.equal(1, 1)
assert.has.errors(function()
	error("this should fail")
end)

return text_traversal
