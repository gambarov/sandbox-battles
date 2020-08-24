local class = require("manada.libs.middleclass")

local Math = class("Math")

local sqrt  = math.sqrt
local cos   = math.cos
local sin   = math.sin
local rad   = math.rad
local floor = math.floor
local max   = math.max
local min   = math.min
local deg   = math.deg
local atan2 = math.atan2

function Math:distanceBetween(vector1, vector2)
    local delta = { x = vector2.x - vector1.x, y = vector2.y - vector1.y }
    return sqrt((delta.x * delta.x) + (delta.y * delta.y))
end

function Math:vectorFromAngle(angle)
    return { x = cos( rad( angle ) ), y = sin( rad( angle ) ) }
end

function Math:limitedAngleBetweenVectors(vector1, vector2, current, turnRate)

	local target = self:angleBetweenVectors(vector1, vector2)
	local delta = floor(target - current)

	delta = self:normaliseAngle(delta)
	delta = self:clamp(delta, -turnRate, turnRate)

	return current + delta
end

function Math:angleBetweenVectors(vector1, vector2)
	local angle = deg( atan2( vector2.y - vector1.y, vector2.x - vector1.x ) ) + 90
	if angle < 0 then angle = 360 + angle end
	return angle
end

function Math:normaliseAngle(angle)
    while angle <= -180 do
		angle = angle + 360
	end

	while angle > 180 do
		angle = angle - 360
	end

    return angle
end

function Math:normalise(value, min, max)
	local result = ( value - min ) / ( max - min )
	if result > 1 then
		result = 1
	end
	return result
end

function Math:round(number, idp)
	local mult = 10 ^ ( idp or 0 )
	return floor( number * mult + 0.5 ) / mult
end

function Math:clamp(value, lowest, highest)
    return max( lowest, min( highest, value ) )
end

return Math