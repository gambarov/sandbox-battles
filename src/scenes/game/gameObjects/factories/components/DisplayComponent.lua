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

    containerObject.intersectsWith = function(self, gameObject)

        if not gameObject or not gameObject["getDisplayObject"] then
            return false
        end 

        local object = self:getDisplayObject()
        local other = gameObject:getDisplayObject()

        if (object.x - object.width / 2 >= other.x - other.width / 2 and 
            object.x - object.width / 2 <= other.x + other.width / 2) and 
           (object.y - object.height >= other.y - object.height and 
            object.y - object.height <= other.y + other.height / 2) then
            return true
        end

        return false
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