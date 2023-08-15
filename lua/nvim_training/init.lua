local Config = require("nvim_training.config")


-- I would like to export this, but I cant work out how to
-- Any help is appreciated. 
local training = {}
function training.config(args)
	for i, v in pairs(args) do
		Config[i] = v
	end
	Config:write_to_json()
	Config:load_from_json()
end

return training