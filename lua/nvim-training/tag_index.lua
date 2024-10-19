local exported_tags = {
	t = { "t", "horizontal", "chair-wise", "right" },
	T = { "T", "horizontal", "chair-wise", "left" },
	F = { "F", "horizontal", "chair-wise", "left" },
	f = { "f", "horizontal", "chair-wise", "right" },
	WORD = { "WORD", "horizontal", "counter", "text-object" },
	word = { "word", "horizontal", "counter", "text-object" },
	sentence = { "sentence", "horizontal, text-object" },
	match = { "match", "text-object" },
	o = { "o", "insert_mode", "linewise" },
	O = { "O", "insert_mode", "linewise" },
	word_end = { "word", "end", "vertical" },
	WORD_end = { "WORD", "end", "vertical" },
	lines_up = { "k", "horizontal", "lines" },
	lines_down = { "j", "horizontal", "lines" },
	word_start = { "word", "horizontal" },
	block = { "text-object", "inside" },
}

return exported_tags
