local user_config = require("nvim-training.user_config")
local utility = require("nvim-training.utility")
local module = {}

local function configure(args)
	for i, v in pairs(args) do
		if not (type(i) == "table") then
			user_config[i] = v
		end
		if type(i) == "table" then
			for ii, vv in pairs(i) do
				user_config[i][ii] = vv
			end
		end
	end
end

function module.configure(args)
	configure(args)
end

function module.setup(args)
	configure(args)
end

return module
