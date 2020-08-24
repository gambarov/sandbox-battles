local class = require("manada.libs.middleclass")

local Timer = class("Timer")

function Timer:initialize(params)

	self.name = "timer"

    self._timers = {}

end

function Timer:update(dt)
end

function Timer:performWithDelay(delay, listener, iterations, name)

    local timer = timer.performWithDelay(delay, listener, iterations);

    name = name or manada.utils:generateUUID() 
    
    self._timers[name] = timer

    return timer, name
end

--- Добавить таймер
-- @param timer Таймер, который нужно добавить
-- @param name Опциональный: Имя таймера
function Timer:add(timer, name)
    if timer then
        self._timers[timer.name or name] = timer
    end
end

--- Получить таймер
-- @param Имя таймера
-- @return Вернет таймер, если такой существует
function Timer:get(name)
    return self._timers[name]
end

--- Приостановить работу таймера
-- @param name Приостановить работу определенного таймера, иначе приостанавливает работу всех таймеров
function Timer:pause(name)
    if name then
        local t = self:get(name)
        if t then
            return timer.pause(t)
        end
    else
        for k, _ in pairs(self._timers) do
            self:pause(k)
        end
    end
end

function Timer:resume(name)
    if name then
        local t = self:get(name)
        if t then
            return timer.resume(t)
        end
    else
        for k, _ in pairs(self._timers) do
            self:resume(k)
        end
    end
end

function Timer:cancel(name)
    if name then
        local t = self:get(name)
        if t then
            timer.cancel(t)
        end
        t = nil
        self._timers[name] = nil
    else
        for k, _ in pairs(self._timers) do
            self:cancel(k)
        end
    end
end

function Timer:destroy()
end

return Timer