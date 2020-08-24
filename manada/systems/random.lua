local class = require("manada.libs.middleclass")

local Random = class("Random")

local random = math.random
local randomseed = math.randomseed
local ostime = os.time

function Random:initialize(params)
    self:seed()
end

function Random:range(min, max)
    -- Значение от 1 до min
    if not max then
        max = min
        min = 1
    end

    return random(min, max)
end

function Random:seed(value)
    randomseed(value or ostime())
end

function Random:fromTable(table)

	local count = manada.utils:countTable(table)
	local index = self:range(1, count)

	local i = 1
	for k, v in pairs(table) do
		if i == index then
			return v, k
		end
		i = i + 1
	end

	return nil

end

return Random