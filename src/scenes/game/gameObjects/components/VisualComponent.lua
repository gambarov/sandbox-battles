local class = require( "manada.libs.middleclass" )

local Component = class( "VisualComponent" )

function Component:initialize( containerObject, params )

    params = params or {}
    self._containerObject = containerObject

    for k, v in pairs( params ) do
        -- Кастомные св-ва
        self[ "_" .. k ] = v

        -- Если текущее св-во — св-во самого экранного объекта
        if self._visual and self._visual[ k ] then
            self._visual[ k ] = v
        end
    end

end

function Component:getVisual()
    return self._visual    
end  

function Component:update()
end

function Component:destroy()
    self._visual = nil;
end

return Component