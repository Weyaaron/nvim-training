local module = {}

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
return module
