local module = {}

local interface_names = { "counter", "target_char", "name", "target_register", "search_target" }

function module.start_task_with_args(child, task_name, args_as_strs)
	local full_arg_str = ""
	if args_as_strs then
		full_arg_str = table.concat(args_as_strs, ",")
	end
	local command = "require('nvim-training').setup( {custom_collections= { UnitTest = { '"
		.. task_name
		.. "' },    }, "
		.. full_arg_str
		.. "   })"
	child.lua(command)
	child.cmd("Training Start RandomScheduler UnitTest")
end

function module.construct_solution_string_from_task_data(task_data)
	local result = task_data.input_template or ""

	for i, v in pairs(interface_names) do
		--Writing this here is easier then messing with the code on the other side
		local current_sub_str = "<" .. v .. ">"
		if v == "target_register" then
			v = '"' .. result:gsub(current_sub_str, tostring(task_data[v]))
			goto continue
		end
		if task_data[v] then
			result = result:gsub(current_sub_str, tostring(task_data[v]))
		end
		-- print(current_sub_str, task_data[v], result)
		::continue::
	end
	-- result = template
	-- result = result:gsub("<target_char>", target_char_from_task)
	-- if result:find("<target_register>") then
	-- 	result = '"' .. result:gsub("<target_register>", target_register)
	-- end
	-- print(task_data.name, template, "input:", result)
	return result
end

function module.load_interface_data_from_child(child)
	local interface_values = child.lua_get("require('nvim-training.commands.command_start').test_interface")
	-- print(vim.inspect(interface_values))
	return interface_values
end

return module
