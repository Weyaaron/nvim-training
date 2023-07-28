local utility = require("nvim_training.utility")
local Config = {}
Config.__index = Config
Config.config_args = { enable_audio_feedback = false }

function Config:new()
	self.__index = self
	local base = {}
	for i, v in pairs(Config.config_args) do
		base[i] = v
	end
	setmetatable(base, self)
	base.current_config_path = utility.construct_project_base_path("current_config.json")

	local current_config_file = io.open(base.current_config_path)
	if current_config_file then
		base:load_from_json()
	end

	return base
end

function Config:load_from_json()
	local file = io.open(self.current_config_path)
	local content = file:read("a")
	local data_from_json = vim.json.decode(content)

	file:close()

	for i, v in pairs(data_from_json) do
		self[i] = v
	end
end

function Config:write_to_json()
	local file = io.open(self.current_config_path, "w")

	local dummy = {}
	for i, v in pairs(Config.config_args) do
		dummy[i] = self[i]
	end
	local data_as_json = vim.json.encode(dummy)
	file:write(data_as_json)
	file:close()
end
return Config
