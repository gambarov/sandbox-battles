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

return Random