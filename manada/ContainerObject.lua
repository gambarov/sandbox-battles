local class = require("manada.libs.middleclass")

local ContainerObject = class("GameObject")

local remove = table.remove

function ContainerObject:initialize(params)

    params = params or {}
    self._components = {} 

end

function ContainerObject:update()
    
    for name, _ in pairs( self._components ) do
        self._components[name]:update()
    end

end

function ContainerObject:add(name, component, params)

    if self._components[name] then
        self:removeComponent(name)
    end

    for i = 1, #component.requires, 1 do
        local requireSystem = component.requires[i]
        assert(self:get(requireSystem), "Component \"" .. name .. "\" required \"" .. requireSystem .. "\" component")
    end

    params = params or {}

    self._components[name] = component:new(self, params)

end

function ContainerObject:remove(name)

    if self:getComponent( name ) then
        self._components[ name ]:destroy()
        self._components[ name ] = nil
        return true
    end

    return false

end

function ContainerObject:get(name)
    
    local component = self._components[ name ]

    if not component then
        print( "WARNING: " .. "Can't get \"" .. name .. "\" component because it's doesn't exist" )
    end

    return component

end

function ContainerObject:destroy()
    -- Удаляем все компоненты объекта
    for name, _ in pairs( self._components ) do
        self:removeComponent( name )
    end

    self._components = nil

end

return ContainerObject