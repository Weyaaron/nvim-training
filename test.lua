


local a = {}
print(#a == 0)

local utility = require("plugin.src.utility")


local total_task_pool = {{"a"}, {"b"}}
local excluded_tags = {}
local included_tags = {"a"}
local current_task_pool = {}

for key, el in pairs(total_task_pool) do
	local allowed_intersection = utility.intersection(el, included_tags)
	local forbidden_intersection = utility.intersection(el, excluded_tags)
	allowed_intersection = {"a"}
	forbidden_intersection = {}
	local first_half = not (allowed_intersection == {})
	local second_half = (forbidden_intersection == {})
	print("F " .. tostring(first_half))
	print("S " .. tostring(second_half))
	if first_half and second_half then
		print("Task pool added")
		current_task_pool[el] = el
	end
end
print(tostring(#current_task_pool))



local AbsoluteLineTask = require("plugin.src.tasks.absolute_line")
local RelativeLineTask = require("plugin.src.tasks.relative_line")
local JumpMarkTask = require("plugin.src.tasks.move_mark")
local WordJumpTask = require("plugin.src.tasks.word_forward_movement")
local BufferPermutationTask = require("plugin.src.tasks.buffer_permutation")

local total_task_pool = { BufferPermutationTask, AbsoluteLineTask, JumpMarkTask }

local global_tag_list = {}
for index, el in pairs(total_task_pool) do
	for inner_index, tag_el in ipairs(el.base_args.tags) do
		global_tag_list[tag_el] = tag_el
	end
end

local included_tags = { "movement" }

function calc_task_list()
	local current_task_pool = {}
	for key, el in pairs(total_task_pool) do
		for tag_key, tag_el in ipairs(el.base_args.tags) do
			if included_tags[tag_el] then
				table.insert(current_task_pool, el)
			end
		end
	end
	return current_task_pool
end
local task_pool = calc_task_list()
