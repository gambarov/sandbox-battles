local class = require("manada.libs.middleclass")

local Math = class("Math")

local sqrt = math.sqrt
local cos  = math.cos
local sin  = math.sin
local rad  = math.rad

function Math:distanceBetween(vector1, vector2)
    local delta = { x = vector2.x - vector1.x, y = vector2.y - vector1.y }
    return sqrt((delta.x * delta.x) + (delta.y * delta.y))
end

function Math:vectorFromAngle(angle)
    return { x = cos( rad( angle ) ), y = sin( rad( angle ) ) }
    -- return { x = cos( rad( angle - 90 ) ), y = sin( rad( angle - 90 ) ) }
end

return Math