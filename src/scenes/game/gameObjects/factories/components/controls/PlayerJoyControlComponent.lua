local class = require( "manada.libs.middleclass" )

local Component = class( "PlayerJoyControlComponent" )

local controller = require( "src.libs.controller.virtual_controller_factory" ).newController()

Component.requires = { "display" }

function Component:initialize( containerObject, params )

    params = params or {}

    self._containerObject = containerObject
    
	local joyRadius = display.contentHeight / 6

    local moveJoyProps = {
		nToCRatio = 0.5,
		radius = joyRadius,
		x = joyRadius * 1.5,
		y = display.contentHeight - (joyRadius * 1.75),
		restingXValue = 0,
		restingYValue = 0,
		rangeX = 200,
		rangeY = 200,
		touchHandler = {
            onTouch = function ( self, x, y )
                if containerObject:hasComponent("display") and containerObject:getDisplayObject().bodyType then
                    containerObject:getDisplayObject():setLinearVelocity(x, y)
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
    self._containerObject = nil

    controller = nil
end

return Component