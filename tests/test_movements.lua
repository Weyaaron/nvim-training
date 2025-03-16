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

local function test_word_movements(movement, line, cursor_pos, counter, target)
	local result = movement(line, cursor_pos, counter)
	MiniTest.expect.equality(result, target)
end

function TestModule.test_fs()
	local nonzero_line = "000x"
	local f_result = movements.f(nonzero_line, 0, "x")
	local F_result = movements.F(nonzero_line, 0, "x")
	MiniTest.expect.equality(f_result, 3)
	MiniTest.expect.equality(F_result, 3)
end

function TestModule.test_word_end_within_words()
	local two_words = "w1w w2w w3w"
	test_word_movements(movements.word_end, two_words, 1, 1, 2)
end

function TestModule.test_word_end_at_word_start()
	local two_words = "w1w w2w w3w"
	test_word_movements(movements.word_end, two_words, 0, 1, 2)
end

function TestModule.test_word_end_at_word_end()
	local two_words = "w1w w2w w3w"
	test_word_movements(movements.word_end, two_words, 2, 1, 6)
end

function TestModule.test_word_end_at_whitespace()
	local two_words = " www  www"
	test_word_movements(movements.word_end, two_words, 0, 1, 4)
end
--Todo: With multiple whitespaces!

function TestModule.word_bounds()
	local words = "www www www"
	local word_bounds = utility.calculate_word_bounds(words)
	MiniTest.expect.equality(word_bounds[1][1], 0)
	MiniTest.expect.equality(word_bounds[1][2], 2)
end


function TestModule.test_Word_end_Within_words()
	local two_words = "w1w w2w w3w"
	test_word_movements(movements.word_end, two_words, 1, 1, 2)
end

function TestModule.test_Word_end_at_word_start()
	local two_words = "w1w w2w w3w"
	test_word_movements(movements.word_end, two_words, 0, 1, 2)
end

function TestModule.test_Word_end_at_word_end()
	local two_words = "w1w w2w w3w"
	test_word_movements(movements.word_end, two_words, 2, 1, 6)
end

return TestModule
