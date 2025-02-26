local module = {}

--Target Register is not included because it messes with the formatting.
local interface_names = { "counter", "target_char", "name", "search_target", "target_quote" }

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
		if task_data[v] then
			result = result:gsub(current_sub_str, tostring(task_data[v]))
		end
	end
	local reg_str = "target_register"
	if result:find(reg_str) then
		result = '"' .. result:gsub("<" .. reg_str .. ">", tostring(task_data[reg_str]))
	end
	return result
end

function module.load_interface_data_from_child(child)
	return child.lua_get("require('nvim-training.commands.command_start').test_interface")
end

return module
