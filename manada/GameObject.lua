local class = require("manada.libs.middleclass")

local GameObject = class("GameObject")

function GameObject:initialize(params)

    params = params or {}

    self._visual = params.visual

    for k, v in pairs(params) do 
        -- Св-ва GameObject
        self["_" .. k] = v

        -- Св-ва DisplayObject
        if self._visual and self._visual[k] then
            self._visual[k] = v
        end
    end

    if self._visual then
        -- Ссылка на себя в визуальном объекте (для событий физики и т.п.)
        self._visual.gameObject = self      
        -- Локальная группа игрового объекта (если требуется)
        if self._localGroup then
            self._localGroup:insert(self._visual)
            self._parentGroup:insert(self._localGroup)
        -- Не требуется
        else
            self._parentGroup:insert(self._visual)
        end
    end

    self._id = manada.utils:generateUUID()  
    self._totalFrames = 0
    self._components = {} 

    manada:addGameObject(self)
end

function GameObject:update(dt)
    -- Обновление счетчика кадров
    self._totalFrames = ((self._totalFrames or 0) + 1)

    if self._components then
        for name, _ in pairs( self._components ) do
            local component = self._components[name]

            if component["update"] then
                component:update(dt)
            end
        end
    end
end

-- МЕТОДЫ DISPLAY OBJECT

function GameObject:getVisual()
    if self._visual then
        return self._visual
    end
end

function GameObject:getParentGroup()
    if self:getVisual() then
        return self._parentGroup
    end
end

function GameObject:getLocalGroup()
    if self:getVisual() then
        return self._localGroup
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
    return { x = self:getX(), y = self:getY() }
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

function GameObject:getAlpha()
    if self:getVisual() then
        return self._visual.getAlpha
    else
        return self._alpha
    end
end

function GameObject:setAlpha(value)
    if self:getVisual() then
        self._visual.alpha = value
    else
        self._alpha = value
    end
end

function GameObject:hide()
    if self:getVisual() then
        self._visual.isVisible = false
    end
end

function GameObject:show()
    if self:getVisual() then
        self._visual.isVisible = true
    end
end

function GameObject:rotate(value)
    self:setRotation(self:getRotation() + value)
end

function GameObject:getAnchor()
    if self:getVisual() then
        return self._visual.anchorX, self._visual.anchorY
    end
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

function GameObject:addEventListener(name, handler)
    if self:getVisual() then
        self._visual:addEventListener(name, handler)
    end
end

function GameObject:removeEventListener(name, handler)
    if self:getVisual() then
        self._visual:removeEventListener(name, handler)
    end
end

-- МЕТОДЫ ДЛЯ РАБОТЫ С КОМПОНЕНТАМИ ОБЪЕКТА

function GameObject:setComponent(name, component, params)
    -- Если имеется попытка добавить компонент уже уничтоженному объкту
    if self:isDestroyed() then
        print("WARNING: Attempt to set a \"" .. name .. "\" component to non-alive \"" .. self:getName() .. "\" GameObject")
        return
    end

    -- Удаляем существующий компонент, если такой есть
    if self:getComponent(name) then
        self:removeComponent(name)
    end

    params = params or {}
    self._components[name] = component:new(self, params)

    if self:isPaused() and self._components[name]["pause"] then
        self._components[name]:pause()
    end
end

function GameObject:getComponent(name)
    if self._components then
        return self._components[name]
    end
end

function GameObject:removeComponent(name)
    -- Уничтожаем существующий компонент
    if self:getComponent(name) then
        self._components[name]:destroy()
        self._components[name] = nil
        return true
    end
    return false
end

-- ПРОЧЕЕ

function GameObject:pause()
    self._isPaused = true

    if self._components then
        for _, component in pairs(self._components) do
            if component["pause"] then
                component:pause()
            end
        end
    end
end

function GameObject:resume()
    self._isPaused = false

    if self._components then
        for _, component in pairs(self._components) do
            if component["resume"] then
                component:resume()
            end
        end
    end
end

function GameObject:contains(point)

    if not point or not point.x or not point.y or not self:getX() or not self:getWidth() then
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

function GameObject:getType()
    return self._type or "none"
end

function GameObject:getID()
    return self._id
end

function GameObject:getFrames()
    return self._totalFrames or 0
end

function GameObject:isPaused()
    return self._isPaused
end

function GameObject:isDestroyed()
    return self._isDestroyed
end

function GameObject:destroy()
    -- Удаление всех компонентов объекта
    self._isDestroyed = true

    if self._components then
        for name, _ in pairs(self._components) do
            self:removeComponent(name)
        end
    end

    self._components = nil

    if self._localGroup then
        self._localGroup:removeSelf()
        self._localGroup = nil
    end

    self._parentGroup = nil

    -- Удаление объекта Display Object
    if self._visual then
        self._visual:removeSelf()
        self._visual = nil
    end
end

return GameObject