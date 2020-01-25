local class = require("manada.libs.middleclass")

local Debug = class("Debug")

local floor, min, max, len = math.floor, math.min, math.max, string.len
 
function Debug:initialize(params)
    self._fontSize = display.pixelHeight * 0.015

    self._updateFreq = params.updateFrequence or (display.fps / 10) -- Частота обновления данных
    self._updateCurr = 0                                            -- Вспомогательный счетчик
    self._prevTime = 0                                              

    self._group = display.newGroup()

    self._messageDelay = params.messageDelay or 1500
    self._messageCount = 0
end

function Debug:update(event)

    if not self._enabled then
        return
    end

    local curTime = system.getTimer()

    if self._updateCurr >= self._updateFreq then
        
        self._updateCurr = 0
        local currentFPS = min(display.fps, floor(1000 / (curTime - self._prevTime)))

        if self._monitor then
            self._monitor.text.text = 
            "FPS: " .. tostring(currentFPS) .. "\n" ..
            "Texture: " .. tostring( floor( system.getInfo( "textureMemoryUsed" ) * 0.0001 ) * 0.01 ) .. "mb " .. "\n" ..
            "System: " .. tostring( floor( collectgarbage( "count" ) * 0.1 ) * 0.01 ) .. "mb " .. "\n" ..
            "StageObjects: " .. tostring( floor( manada.utils:deepNumChildren( display.getCurrentStage() ) ) ) ..  "\n" .. 
            "GameObjects: " .. tostring(#manada:getGameObjects())
        end
    end

    self._group:toFront()
    self._prevTime = curTime
    self._updateCurr = self._updateCurr + 1
end

function Debug:message(text)

    if not self._enabled then
        return
    end

    local width  = len(text) * (self._fontSize / 1.75)
    local height = self._fontSize * 1.25 * manada.utils:count(manada.utils:splite(text, "\n"))

    local group = self:__createTextBox(display.newGroup(), text, display.pixelHeight * 0.15, height * self._messageCount, width, height)
    group.isMessage = true

    self._group:insert(group)
    self._messageCount = self._messageCount + 1

    -- Удаление сообщения через секунду
    timer.performWithDelay(self._messageDelay, function ()
        -- Сначало постепенно изчезает, затем удаляется
        transition.to(group, { alpha = 0, time = 300, onComplete = 
            function() 
                -- Очищение памяти
                display.remove(group)
                group = nil
                self._messageCount = self._messageCount - 1

                -- Сдвигаем все сообщения наверх
                for i = 1, self._group.numChildren do
                    local group = self._group[i]
                    if group.isMessage then
                        group:translate(0, -group.height)
                    end
                end
            end })
    end)
end

function Debug:enable()
    if not self._enabled then
        self._enabled = true
        self._monitor = self:__createTextBox(display.newGroup(), "", 0, 0, display.pixelHeight * 0.15,  display.pixelWidth * 0.2)
        self._group:insert(self._monitor)
    end
end

function Debug:disable()
    self._enabled = false
    self._monitor = nil
    
    for i = self._group.numChildren, 1, -1 do
        self._group[i]:removeSelf()
        self._group[i] = nil
    end
end

function Debug:__createTextBox(displayGroup, text, x, y, width, height)
    local background = display.newRect(displayGroup, x, y, width, height)
    background.anchorX = 0
	background.anchorY = 0
	background:setFillColor( 0 )
    background.alpha = 0.65

    local label = display.newText(
    {
        parent = displayGroup, 
        text = text, 
        x = x + width / 2, 
        y = y + height / 1.65,
        width = width,
        height = height, 
        font = native.systemFont, 
        fontSize = self._fontSize, 
        align = "center" 
    })
    label:setFillColor( 1 )
    
    displayGroup.background = background
    displayGroup.text = label
    return displayGroup
end

return Debug