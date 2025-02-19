



local function generic_f(task, text_object)
	text_object:setup(task.target_char)
end

module = { f = generic_f, t = generic_f }
return module
