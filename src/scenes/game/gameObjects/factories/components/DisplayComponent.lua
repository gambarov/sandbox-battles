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

    containerObject.getDisplayObject = function()
        return self._displayObject
    end

end

function Component:update()
end

function Component:destroy()
    self._containerObject.getDisplayObject = nil
    self._containerObject = nil

    display.remove(self._displayObject)
    self._displayObject = nil;
    
end

return Component