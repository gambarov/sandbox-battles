local class = require( "manada.libs.middleclass" )

local Component = class( "PlayerJoyControlComponent" )

local controller = require( "src.libs.controller.virtual_controller_factory" ).newController()

function Component:initialize( gameObject, params )

    params = params or {}

    self._gameObject = gameObject
    
	local joyRadius = ((display.pixelHeight * 0.1) + (display.pixelWidth * 0.1)) / 2

    local moveJoyProps = {
		nToCRatio = 0.5,
		radius = joyRadius,
		x = display.pixelHeight * 0.15,
		y = display.pixelWidth * 0.80,
		restingXValue = 0,
		restingYValue = 0,
		rangeX = 200,
		rangeY = 200,
		touchHandler = {
            onTouch = function ( self, x, y )
                if gameObject:getVisual() and gameObject:getVisual().bodyType then
                    gameObject:getVisual():setLinearVelocity(x, y)
                end
            end
		}
    }

    self._moveJoy = controller:addJoystick( "moveJoystick", moveJoyProps )
    self._displayGroup = params.displayGroup or display.newGroup()

    controller:displayController( self._displayGroup )
end

function Component:update(dt)
end

function Component:destroy()

    display.remove(self._moveJoy.nob)
    display.remove(self._moveJoy.container)

    self._moveJoy = nil
    self._displayGroup = nil
    self._gameObject = nil
end

return Component