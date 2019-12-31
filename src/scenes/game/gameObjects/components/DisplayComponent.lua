local class = require( "manada.libs.middleclass" )

local Component = class( "DisplayComponent" )

Component.requires = {}

function Component:initialize( containerObject, params )

    params = params or {}
    self._containerObject = containerObject

    for k, v in pairs( params ) do
        -- Кастомные св-ва
        self[ "_" .. k ] = v

        -- Назначение св-в самого экранного объекта
        if self._displayObject and self._displayObject[ k ] then
            self._displayObject[ k ] = v
        end
    end

end

function Component:getObject()
    return self._displayObject    
end  

function Component:update()
end

function Component:destroy()
    display.remove(self._displayObject)
    self._displayObject = nil;
end

return Component