local class = require("manada.libs.middleclass")

local ContainerObject = class("GameObject")

local remove = table.remove

function ContainerObject:initialize(params)

    params = params or {}
    self._components = {} 

end

function ContainerObject:update(dt)
    
    if self._components then
        for name, _ in pairs( self._components ) do
            self._components[name]:update(dt)
        end
    end

end

function ContainerObject:set(name, component, params)
    -- Удаляем существующий компонент, если такой есть
    if self:has(name) then
        self:remove(name)
    end

    -- Проверка зависимостей
    for i = 1, #component.requires, 1 do
        local requireSystem = component.requires[i]
        assert(self:has(requireSystem), "Component \"" .. name .. "\" required \"" .. requireSystem .. "\" component")
    end

    params = params or {}
    self._components[name] = component:new(self, params)

end

function ContainerObject:remove(name)

    if self:has(name) then
        self._components[ name ]:destroy()
        self._components[ name ] = nil
        return true
    end

    return false

end

function ContainerObject:get(name)
    
    assert(self._components, "Сan’t get \"" .. name .. "\" component because no component has been added yet")
    local component = self._components[name]
    assert(component, "Can't get \"" .. name .. "\" component because it's don't exist")
    return component

end

function ContainerObject:has(name)

    if not self._components then
        return false
    end

    return not self._components[name] == nil
end

function ContainerObject:destroy()
    -- Удаляем все компоненты объекта
    for name, _ in pairs( self._components ) do
        self:remove( name )
    end

    self._components = nil

end

return ContainerObject