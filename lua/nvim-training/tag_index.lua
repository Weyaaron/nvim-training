local exported_tags = {
	block = { "text-object", "inside" },
	cchange = { "cchange", "operator" },
	change = { "change" },
	deletion = { "deletion", "operator", "register" },
	F = { "F", "horizontal", "chair-wise", "left" },
	f = { "f", "horizontal", "chair-wise", "right" },
	lines_down = { "j", "horizontal", "lines" },
	lines_up = { "k", "horizontal", "lines" },
	line = { "line", "lines" },
	match = { "match", "text-object" },
	movement = { "movement", "operator" },
	o = { "o", "insert_mode", "linewise" },
	O = { "O", "insert_mode", "linewise" },
	quotes = { "quotes" },
	sentence = { "sentence", "horizontal", "text-object" },
	T = { "T", "horizontal", "chair-wise", "left" },
	t = { "t", "horizontal", "chair-wise", "right" },
	word_end = { "word_end", "end", "vertical" },
	WORD_end = { "WORD_end", "END", "vertical" },
	treesitter = { "treesitter", "custom", "programming" },
	programming = { "programming" },
	word_start = { "word", "horizontal" },
	word = { "word", "horizontal", "counter", "text-object" },
	WORD = { "WORD", "horizontal", "counter", "text-object" },
	yank = { "yank", "register", "operator" },
}

return exported_tags
