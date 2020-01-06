local class = require( "manada.libs.middleclass" )

local Time = class( "Time" )

local getTimer = system.getTimer
local time = os.time

function Time:initialize( params )

	self.name = "time"

	self._dt = 0
	self._previousTime = 0
	self._fpsFactor = 1000 / display.fps
    self._frames = 0
    
	self._start = time()
end

function Time:update( event )
	
	self._frames = self._frames + 1

	local timer = getTimer()
	self._dt = ( timer - self._previousTime ) / self._fpsFactor
	self._previousTime = timer

	self._fps = ( self._frames / ( time() - self._start ) ) or 0
end

function Time:delta()
	return self._dt
end

function Time:fps()
	return self._fps
end

function Time:destroy()

	self._dt = nil
	self._previousTime = nil
    self._fpsFactor = nil
end

return Time
