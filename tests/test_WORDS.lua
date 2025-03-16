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
