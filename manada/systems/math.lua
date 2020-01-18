local class = require("manada.libs.middleclass")

local Math = class("Math")

local sqrt  = math.sqrt
local cos   = math.cos
local sin   = math.sin
local rad   = math.rad
local floor = math.floor

function Math:distanceBetween(vector1, vector2)
    local delta = { x = vector2.x - vector1.x, y = vector2.y - vector1.y }
    return sqrt((delta.x * delta.x) + (delta.y * delta.y))
end

function Math:vectorFromAngle(angle)
    return { x = cos( rad( angle ) ), y = sin( rad( angle ) ) }
    -- return { x = cos( rad( angle - 90 ) ), y = sin( rad( angle - 90 ) ) }
end

function Math:round( number, idp )
	local mult = 10 ^ ( idp or 0 )
	return floor( number * mult + 0.5 ) / mult
end


return Math