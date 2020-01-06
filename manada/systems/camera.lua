local class = require("manada.libs.middleclass")

local Camera = class("Camera")

function Camera:initialize(params)
    self._cameras = {}
end

function Camera:add(name, params)
    self._cameras[name] = params
    self:set(name)
end

function Camera:set(name)

    local camera = self._cameras[name]
    
    if camera then
        self._activeCamera = camera
    end
end

function Camera:remove(name)

    local camera = self._cameras[name]

    -- Если удаляется текущая камера, то сбрасываем позицию в центр
    if self._cameras[name] and self._activeCamera and self._cameras[name] == self._activeCamera then
        local parent = self._activeCamera.parent
        self._activeCamera = nil
        parent.x, parent.y = math.floor(0.5 * display.pixelHeight), math.floor(0.5 * display.pixelWidth)
        parent = nil
    end
    
    self._cameras[name] = nil
end

function Camera:update(dt)
    
    if self._activeCamera then

        local target = self._activeCamera["target"]
        local parent = self._activeCamera["parent"]
        local speed  = self._activeCamera["speed"]

        -- Если в данный момент в фокусе родительская группа, то слежение за объектом не действует
        if parent and parent.isFocus then
            return
        end

        -- Слежение камеры за целью
        if target and target.x and target.y then
            local x, y = target:localToContent( 0, 0 )                                      -- Получаем глобальные координаты цели (т.е. относительно самого экрана)
            x, y = display.contentCenterX - x, display.contentCenterY - y                   -- Получаем нужное смещение
            parent.x, parent.y = parent.x + (x / speed * dt), parent.y + (y / speed * dt)
        end
    end
end

function Camera:destroy()
    self._activeCamera = nil
    self._cameras = nil
end

return Camera