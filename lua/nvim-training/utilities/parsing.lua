local module = {}

function module.complete_from_text_list(arg_lead, texts)
	local matching_texts = {}
	for i, text_el in pairs(texts) do
		local sub_str = text_el:sub(1, #arg_lead)
		if sub_str == arg_lead then
			matching_texts[#matching_texts + 1] = text_el
		end
	end

	return matching_texts
end

function module.match_text_list_to_args(texts, args)
	local matching_texts = {}
	for i, arg_el in pairs(args) do
		for ii, text_el in pairs(texts) do
			if arg_el == text_el then
				matching_texts[#matching_texts + 1] = text_el
			end
		end
	end
	return matching_texts
end

return module
