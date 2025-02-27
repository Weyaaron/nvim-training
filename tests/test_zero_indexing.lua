local movements = require("nvim-training.movements")
local utility = require("nvim-training.utility")

local child = MiniTest.new_child_neovim()

local TestModule = MiniTest.new_set({
	hooks = {
		pre_case = function()
			-- Restart child process with custom 'init.lua' script
			child.restart({ "-u", "scripts/minimal_init.lua" })
			-- Load tested plugin
			-- child.lua([[M = require('nvim-training')]])
		end,
		-- Stop once all test cases are finished
		post_once = child.stop,
	},
	-- n_retry = 3,
})

function test_movement_from_zero(line, movement, counter)
	return movement(line, 0, counter)
end

function test_movement_from_nonzero(line, movement, cursor_pos, counter)
	return movement(line, cursor_pos, counter)
end

function TestModule.test_fs()
	local nonzero_line = "000x"
	local f_result = movements.f(nonzero_line, 0, "x")
	local F_result = movements.F(nonzero_line, 0, "x")
	MiniTest.expect.equality(f_result, 3)
	MiniTest.expect.equality(F_result, 3)
end

function TestModule.test_words()
	local two_words = "w1 w2 w3"
	local result = movements.words(two_words, 0, 1)
	MiniTest.expect.equality(result, 3)

	local result = movements.words(two_words, 0, 2)
	MiniTest.expect.equality(result, 6)
end

function TestModule.test_WORDS()
	local two_words = "w1-w2 w3-w4 w5-w6"
	MiniTest.expect.equality(test_movement_from_zero(two_words, movements.WORDS, 1), 6)
	MiniTest.expect.equality(test_movement_from_zero(two_words, movements.WORDS, 2), 12)
end
function TestModule.test_word_ends()
	local two_words = "w1 w2 w3"

	MiniTest.expect.equality(test_movement_from_zero(two_words, movements.word_end, 1), 1)
	MiniTest.expect.equality(test_movement_from_zero(two_words, movements.word_end, 2), 4)
end
function TestModule.test_WORD_ends()
	local two_words = "w1-w2 w3-w4 w5-w6"

	MiniTest.expect.equality(test_movement_from_zero(two_words, movements.WORD_end, 1), 4)
	MiniTest.expect.equality(test_movement_from_zero(two_words, movements.WORD_end, 2), 9)
end
function TestModule.test_word_starts()
	local two_words = "w1 w2 w3 w4 w5-w6"

	MiniTest.expect.equality(test_movement_from_nonzero(two_words, movements.word_start, 1, 1), 0)
	MiniTest.expect.equality(test_movement_from_nonzero(two_words, movements.word_start, 4, 2), 0)
end

function TestModule.test_WORD_starts()
	local two_words = "w1-w2 w3-w4 w5-w6"
	MiniTest.expect.eqality(test_movement_from_nonzero(two_words, movements.WORD_start, 1, 1), 0)
	MiniTest.expect.equality(test_movement_from_nonzero(two_words, movements.WORD_start, 7, 2), 0)
end

function TestModule.text_extraction()
	local line = "    a"
	local target = movements.f(line, 0, "a")
	local text = utility.extract_text(line, 0, target)
	MiniTest.expect.equality(#line, #text)
	print(text)
end

return TestModule
