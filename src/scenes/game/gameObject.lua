local class = require( "manada.libs.middleclass" )

local GameObject = class( "GameObject" )

local remove = table.remove

function GameObject:initialize(params)

   self._components = {} 
    
end

function GameObject:removeComponent(name)
    
    if not self._components[ name ] then
        print( "WARNING: " .. "Can't remove nil component" )
        return false
    end

    self._components[ name ]:destroy()
    self._components[ name ] = nil
    return true

end

function GameObject:addComponent(name, component)

    if self._components[ name ] then
        self:removeComponent(name)
    end

    self._components[name] = component:new(self._displayObject)

end

function GameObject:destroy()
    -- Удаляем все компоненты объекта
    for name, _ in pairs( self._components ) do
        self:removeComponent(name)
    end

    self._components = nil

    -- Удаляем экранный объект
    display.remove( self._displayObject )
    self._displayObject = nil

end

return GameObject