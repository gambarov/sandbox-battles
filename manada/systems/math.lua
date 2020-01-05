local class = require("manada.libs.middleclass")

local Math = class("Math")

local sqrt = math.sqrt

function Math:distanceBetween(vector1, vector2)
    local delta = { x = vector2.x - vector1.x, y = vector2.y - vector1.y }
    return sqrt((delta.x * delta.x) + (delta.y * delta.y))
end

return Math
