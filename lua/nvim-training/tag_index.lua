local exported_tags = {
	t = "t, horizontal, chair-wise, right",
	T = "T, horizontal, chair-wise, left",
	F = "F, horizontal, chair-wise, left",
	f = "f, horizontal, chair-wise, right",
	WORDS = "WORDS, horizontal, counter, text-object,",
	words = "words, horizontal, counter, text-object",
	sentence = "sentence, horizontal, text-object",
	match = "match, text-object",
	o = "o, insert_mode, linewise",
	O = "O, insert_mode, linewise",
	word_end = "word, end, vertical",
	WORD_end = "WORDS, end, vertical",
	lines_up = "k, horizontal, lines",
	lines_down = "j, horizontal, lines",
	word_start = "word, horizontal",
}

for i, v in pairs(exported_tags) do
	exported_tags[i] = ", " .. v .. ", "
end

return exported_tags
