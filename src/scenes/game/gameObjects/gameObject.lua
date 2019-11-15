local class = require( "manada.libs.middleclass" )

local GameObject = class( "GameObject" )

local remove = table.remove

function GameObject:initialize( params )

    params = params or {}
    self._components = {} 
   
    for k, v in pairs( params ) do
        -- Кастомные св-ва
        self[ "_" .. k ] = v

        -- Если текущее св-во — св-во самого экранного объекта
        if self._visual and self._visual[ k ] then
            self._visual[ k ] = v
        end
    end

end

function GameObject:update()
    
    for name, _ in pairs( self._components ) do
        self._components[name]:update()
    end

end

function GameObject:addComponent(name, component, params)

    if self._components[ name ] then
        self:removeComponent(name)
    end

    params = params or {}

    self._components[ name ] = component:new( self:getVisual(), params )

end

function GameObject:removeComponent(name)

    if not self._components[ name ] then
        print( "WARNING: " .. "Can't remove \"" .. name .. "\" component because it's doesn't exist" )
        return false
    end

    self._components[ name ]:destroy()
    self._components[ name ] = nil
    return true

end

function GameObject:getVisual()
    return self._visual
end

function GameObject:destroy()
    -- Удаляем все компоненты объекта
    for name, _ in pairs( self._components ) do
        self:removeComponent(name)
    end

    self._components = nil

    -- Удаляем экранный объект
    display.remove( self._visual )
    self._visual = nil

end

return GameObject