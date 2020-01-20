local class = require("manada.libs.middleclass")

local GameObject = class("GameObject")

function GameObject:initialize(params)

    params = params or {}

    self._visual = params.visual

    for k, v in pairs(params) do 
        -- TODO: Св-ва GameObject
        self["_" .. k] = v

        -- Св-ва DisplayObject
        if self._visual and self._visual[k] then
            self._visual[k] = v
        end
    end

    if self._visual then
        self._visual.gameObject = self
    end

    self._totalFrames = 0
    self._components = {} 
end

function GameObject:update(dt)
    
    self._totalFrames = ((self._totalFrames or 0) + 1)

    if self._components then
        for name, _ in pairs( self._components ) do
            self._components[name]:update(dt)
        end
    end
end

-- МЕТОДЫ DISPLAY OBJECT

function GameObject:getVisual(prop)
    if self._visual then
        return self._visual
    end
end

function GameObject:getParent()
    if self:getVisual() then
        return self._visual.parent
    end
end

function GameObject:getX()
    if self:getVisual() then
        return self._visual.x
    else
        return self._x
    end
end

function GameObject:getY()
    if self:getVisual() then
        return self._visual.y
    else
        return self._y
    end
end

function GameObject:setX(value)
    if self:getVisual() then
        self._visual.x = value
    else
        self._x = value
    end
end

function GameObject:setY(value)
    if self:getVisual() then
        self._visual.y = value
    else
        self._y = value
    end
end

function GameObject:getPosition()
    return self:getX(), self:getY()
end

function GameObject:setPosition(x, y)
    self:setX(x)
    self:setY(y)
end

function GameObject:getWidth()
    if self:getVisual() then
        return self._visual.width
    end
end

function GameObject:getHeight()
    if self:getVisual() then
        return self._visual.height
    end
end

function GameObject:setWidth(value)
    if self:getVisual() then
        self._visual.width = value
    else
        self._width = value
    end
end

function GameObject:setHeight(value)
    if self:getVisual() then
        self._visual.height = value
    else
        self._height = value
    end
end

function GameObject:getRotation()
    if self:getVisual() then
        return self._visual.rotation
    else
        return self._rotation
    end
end

function GameObject:setRotation(value)
    if self:getVisual() then
        self._visual.rotation = value
    else
        self._rotation = value
    end
end

function GameObject:rotate(value)
    self:setRotation(self:getRotation() + value)
end

function GameObject:setAnchor(x, y)
    if self:getVisual() then
        self._visual.anchorX, self._visual.anchorY = x, y
    end
end

function GameObject:dispatchEvent(name, params)
    if self:getVisual() then
        params = params or {}
        params.name = name
        self._visual:dispatchEvent(params)
    end
end

-- МЕТОДЫ ДЛЯ РАБОТЫ С КОМПОНЕНТАМИ ОБЪЕКТА

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

-- ПРОЧЕЕ

function GameObject:contains(point)

    if not point or not point.x or not point.y or self:destroyed() then
        return false
    end

    return (point.x >= self:getX() - self:getWidth()  / 2 and point.x <= self:getX() + self:getWidth()  / 2) and
           (point.y >= self:getY() - self:getHeight() / 2 and point.y <= self:getY() + self:getHeight() / 2)
end

function GameObject:getName()
    if self._name then
        return self._name
    end

    return "GameObject"
end

function GameObject:getFrames()
    return self._totalFrames or 0
end

function GameObject:destroy()
    -- Удаление всех компонентов объекта
    if self._components then
        for name, _ in pairs(self._components) do
            self:removeComponent(name)
        end
    end

    self._components = nil

    -- Удаление объекта Display Object
    if self._visual then
        self._visual:removeSelf()
        self._visual = nil
    end

    self._destroyed = true
end

function GameObject:destroyed()
    return self._destroyed
end

return GameObject