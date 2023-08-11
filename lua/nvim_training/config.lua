local utility = require("nvim_training.utility")
local Config = {}
local keys = { "enable_audio_feedback", "included_tags", "excluded_tags" }

function Config:load_from_json()
	local current_config_path = utility.construct_project_base_path("current_config.json")
	local file = io.open(current_config_path)
	local content = file:read("a")
	local data_from_json = vim.json.decode(content)

	file:close()

	for i, v in pairs(data_from_json) do
		self[i] = v
	end
end

function Config:write_to_json()
	local current_config_path = utility.construct_project_base_path("current_config.json")
	local file = io.open(current_config_path, "w")

	local data = {}
	for i, v in pairs(keys) do
		data[v] = self[v]
	end

	local data_as_json = vim.json.encode(data)
	file:write(data_as_json)
	file:close()
end
--Not quite sure why this has to exist, it somehow has to?
Config:load_from_json()
return Config
