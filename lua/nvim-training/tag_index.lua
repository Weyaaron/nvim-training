local exported_tags = {
	block = { "text-object", "inside" },
	change = { "change" },
	deletion = { "deletion" },
	F = { "F", "horizontal", "chair-wise", "left" },
	f = { "f", "horizontal", "chair-wise", "right" },
	lines_down = { "j", "horizontal", "lines" },
	lines_up = { "k", "horizontal", "lines" },
	match = { "match", "text-object" },
	movement = { "movement" },
	o = { "o", "insert_mode", "linewise" },
	O = { "O", "insert_mode", "linewise" },
	sentence = { "sentence", "horizontal, text-object" },
	T = { "T", "horizontal", "chair-wise", "left" },
	t = { "t", "horizontal", "chair-wise", "right" },
	word_end = { "word", "end", "vertical" },
	WORD_end = { "WORD", "end", "vertical" },
	word_start = { "word", "horizontal" },
	word = { "word", "horizontal", "counter", "text-object" },
	WORD = { "WORD", "horizontal", "counter", "text-object" },
	yank = { "yank", "register" },
}

return exported_tags
