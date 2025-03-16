local movements = require("nvim-training.movements")
local utility = require("nvim-training.utility")

local child = MiniTest.new_child_neovim()

local TestModule = MiniTest.new_set({
	hooks = {
		pre_case = function()
			child.restart({ "-u", "scripts/minimal_init.lua" })
		end,
		post_once = child.stop,
	},
})

local random_index = 101012

-- function TestModule.test_on_error()
-- 	for i = 1, 10 do
-- 		math.randomseed(random_index + i)
-- 		local line = utility.construct_words_line()
-- 		print(line)
-- 		for ii = 1, 10, 1 do
-- 			for iii = 1, 5, 1 do
-- 				print("(", i, ii, iii, ")")
-- 				local result = movements.words(line, ii, iii)
-- 				-- MiniTest.expect.error(movements.words(line, ii, iii))
-- 			end
-- 		end
-- 	end
-- end

-- function TestModule.test_on_error_locally()
-- 	math.randomseed(5)
-- 	local line = utility.construct_words_line()
-- 	-- print(line)
-- 	local result = movements.words(line, 21, 2)
--
-- 	local word_bounds = utility.calculate_word_bounds(line)
-- 	for i, boundary_pair in pairs(word_bounds) do
-- 		local sub_word = line:sub(boundary_pair[1], boundary_pair[2] + 1)
-- 		-- print(vim.inspect(boundary_pair), sub_word)
-- 		print(vim.inspect(boundary_pair))
-- 	end
-- 	print(vim.inspect(word_bounds[12]), vim.inspect(word_bounds[13]))
-- 	local word_index_cursor = utility.calculate_word_index_from_cursor_pos(word_bounds, 21)
-- 	print(vim.inspect(word_index_cursor))
-- 	--This 30 has been found experimentally
-- 	MiniTest.expect.equality(30, -1)
-- 	MiniTest.expect.equality(result, -1)
-- 	-- MiniTest.expect.error(movements.words(line, ii, iii))
-- end

function TestModule.test_words_within_words()
	local line = "w w w"
	local result = movements.words(line, 1, 1)
	MiniTest.expect.equality(result, 2)
end

function TestModule.test_words_within_words_counter()
	local line = "w www www wwww"
	local result = movements.words(line, 1, 2)
	MiniTest.expect.equality(result, 6)
end

function TestModule.test_words_at_word_end()
	local line = "w1 w"
	local result = movements.words(line, 1, 1)
	MiniTest.expect.equality(result, 3)
end

function TestModule.test_words_at_word_end_counter()
	local line = "ww ww ww"
	local result = movements.words(line, 1, 2)
	MiniTest.expect.equality(result, 6)
end

function TestModule.test_words_at_word_start_counter()
	local line = "ww ww ww"
	local result = movements.words(line, 0, 2)
	MiniTest.expect.equality(result, 6)
end

function TestModule.single_character_word()
	local line = "w w"
	local result = movements.words(line, 0, 1)
	MiniTest.expect.equality(result, 2)
end

function TestModule.single_character_word_counter()
	local line = "w w w"
	local result = movements.words(line, 0, 2)
	MiniTest.expect.equality(result, 4)
end

function TestModule.test_words_at_whitespace()
	local line = " w2"
	local result = movements.words(line, 0, 1)
	MiniTest.expect.equality(result, 1)
end

function TestModule.test_words_with_multiplewhitespace()
	local line = "w   w"
	local result = movements.words(line, 0, 1)
	MiniTest.expect.equality(result, 4)
end

function TestModule.test_words_at_multiple_whitespace()
	local line = "  w2"
	local result = movements.words(line, 0, 1)
	MiniTest.expect.equality(result, 2)
end

function TestModule.word_bounds()
	local line = "www www www"
	local word_bounds = utility.calculate_word_bounds(line)
	MiniTest.expect.equality(word_bounds[1][1], 0)
	MiniTest.expect.equality(word_bounds[1][2], 2)
end

return TestModule
