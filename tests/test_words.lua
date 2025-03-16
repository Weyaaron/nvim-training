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

function TestModule.WORD_bounds()
	local line = "w--w www"
	local word_bounds = utility.calculate_WORD_bounds(words)
	MiniTest.expect.equality(word_bounds[1][1], 0)
	MiniTest.expect.equality(word_bounds[1][2], 3)
end

function TestModule.test_WORDS_within_Words()
	local line = "w1w-w2w w3w"
	local result = movements.WORDS(line, 1, 1)
	MiniTest.expect.equality(result, 2)
end

function TestModule.test_WORDS_at_Word_end()
	local line = "w1-w2 w3"
	local result = movements.WORDS(line, 4, 1)
	MiniTest.expect.equality(result, 6)
end

function TestModule.test_WORDS_at_Word_start()
	local line = "w1-w2 w2"
	local result = movements.WORDS(line, 0, 1)
	MiniTest.expect.equality(result, 6)
end

function TestModule.test_WORDS_within_words()
	local line = "w-w w"
	local result = movements.WORDS(line, 3, 1)
	MiniTest.expect.equality(result, 4)
end

function TestModule.test_WORDS_within_words_counter()
	local line = "w www www wwww"
	local result = movements.WORDS(line, 1, 2)
	MiniTest.expect.equality(result, 6)
end

function TestModule.test_WORDS_at_word_end()
	local line = "w1 w"
	local result = movements.WORDS(line, 1, 1)
	MiniTest.expect.equality(result, 3)
end

function TestModule.test_WORDS_at_word_end_counter()
	local line = "ww ww ww"
	local result = movements.WORDS(line, 1, 2)
	MiniTest.expect.equality(result, 6)
end

function TestModule.single_character_word()
	local line = "w w"
	local result = movements.WORDS(line, 0, 1)
	MiniTest.expect.equality(result, 2)
end

function TestModule.single_character_word_counter()
	local line = "w w w"
	local result = movements.WORDS(line, 0, 2)
	MiniTest.expect.equality(result, 4)
end

function TestModule.test_WORDS_multiple_whitespaces()
	local line = "w   w"
	local result = movements.WORDS(line, 0, 1)
	MiniTest.expect.equality(result, 4)
end

function TestModule.test_WORDS()
	local line = "  w2"
	local result = movements.WORDS(line, 0, 1)
	MiniTest.expect.equality(result, 2)
end

return TestModule
