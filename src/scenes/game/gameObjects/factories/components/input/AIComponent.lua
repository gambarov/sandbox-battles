local class = require( "manada.libs.middleclass" )

local Component = class( "AIControlComponent" )

Component.requires = { }

function Component:initialize( gameObject, params )

    params = params or {}
    self._gameObject = gameObject
end

function Component:update(dt)

    local visual = self._gameObject:getVisual()

    if visual and visual.bodyType then
        -- self._gameObject:rotate(1 * dt)
    end
end

function Component:destroy()
    self._gameObject = nil
end

return Component