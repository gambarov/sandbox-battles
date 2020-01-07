local class = require("manada.libs.middleclass")

local GameObject = class("GameObject")

local remove = table.remove

function GameObject:initialize(params)
    params = params or {}
    self._components = {} 
end

function GameObject:update(dt)
    
    self._totalFrames = (self._totalFrames or 0) + 1

    if self._components then
        for name, _ in pairs( self._components ) do
            self._components[name]:update(dt)
        end
    end

end

function GameObject:setComponent(name, component, params)
    -- Удаляем существующий компонент, если такой есть
    if self:hasComponent(name) then
        self:removeComponent(name)
    end

    -- Проверка зависимостей
    for i = 1, #component.requires, 1 do
        local requireSystem = component.requires[i]
        assert(self:hasComponent(requireSystem), "Component \"" .. name .. "\" required \"" .. requireSystem .. "\" component")
    end

    params = params or {}
    self._components[name] = component:new(self, params)

end

function GameObject:removeComponent(name)

    if self:hasComponent(name) then
        self._components[ name ]:destroy()
        self._components[ name ] = nil
        return true
    end

    return false
end

function GameObject:getComponent(name)
    
    assert(self._components, "Сan’t get \"" .. name .. "\" component because no component has been added yet")
    local component = self:hasComponent(name)
    assert(component, "Can't get \"" .. name .. "\" component because it's don't exist")
    return component

end

function GameObject:hasComponent(name)

    if not self._components then
        return false
    end

    return self._components[name]
end

function GameObject:getFrames()
    return self._totalFrames or 0
end

function GameObject:destroy()
    -- Удаляем все компоненты объекта
    if self._components then
        for name, _ in pairs(self._components) do
            self:removeComponent(name)
        end
    end

    self._components = nil
    self._destroyed = true
end

function GameObject:destroyed()
    return self._destroyed
end

return GameObject