local movements = require("nvim-training.movements")

local child = MiniTest.new_child_neovim()

local TestModule = MiniTest.new_set({
	hooks = {
		pre_case = function()
			child.restart({ "-u", "scripts/minimal_init.lua" })
		end,
		post_once = child.stop,
	},
})

function TestModule.test_word_end_inside_word()
	local line = "w1w w2w w3w"
	local result = movements.word_end(line, 1, 1)
	MiniTest.expect.equality(result, 2)
end

function TestModule.test_word_end_within_words()
	local line = "w1w w2w w3w"
	local result = movements.word_end(line, 3, 1)
	MiniTest.expect.equality(result, 6)
end

function TestModule.test_word_end_at_word_start()
	local line = "w1w w2w w3w"
	local result = movements.word_end(line, 0, 1)
	MiniTest.expect.equality(result, 2)
end

function TestModule.test_word_end_at_word_end()
	local line = "ww ww w3w"
	local result = movements.word_end(line, 1, 1)
	MiniTest.expect.equality(result, 4)
end

return TestModule
