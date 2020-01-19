local class = require("manada.libs.middleclass")

local Debug = class("Debug")

local floor, min, len = math.floor, math.min, string.len

function Debug:initialize(params)

    self._enabled = params.enabled or false
    self._fontSize = params.fontSize or 32

    self._updateFreq = params.updateFrequence or (display.fps / 10) -- Частота обновления данных
    self._updateCurr = 0                                            -- Вспомогательный счетчик
    self._prevTime = 0                                              

    self._group = display.newGroup()
    self._messageCount = 0

    if self._enabled then
        self:enable()
    end
end

function Debug:update(event)

    if not self._enabled then
        return
    end

    local curTime = system.getTimer()

    if self._updateCurr >= self._updateFreq then
        
        self._updateCurr = 0
        local currentFPS = min(display.fps, floor(1000 / (curTime - self._prevTime)))

        if self._group.monitor then
            self._group.monitor.text.text = 
            "FPS: " .. tostring(currentFPS) .. "\n" ..
            "Texture: " .. tostring( floor( system.getInfo( "textureMemoryUsed" ) * 0.0001 ) * 0.01 ) .. "mb " .. "\n" ..
            "System: " .. tostring( floor( collectgarbage( "count" ) * 0.1 ) * 0.01 ) .. "mb " .. "\n" ..
            "Objects: " .. tostring( floor( manada.utils:deepNumChildren( display.getCurrentStage() ) ) )
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

    local group = display.newGroup()
    group.isMessage = true

    local background = display.newRect(group, display.pixelHeight * 0.125, self._fontSize * 1.25 * self._messageCount, len(text) * (self._fontSize / 2),  self._fontSize * 1.25)
    background.anchorX = 0
	background.anchorY = 0
	background:setFillColor( 0 )
    background.alpha = 0.65

    local msgText = display.newText(group, text, background.x + background.width / 2, background.y + background.height / 2, native.systemFont, self._fontSize)
    msgText:setFillColor( 1 )

    self._group:insert(group)
    self._messageCount = self._messageCount + 1

    timer.performWithDelay(1000, function ()
        transition.to(group, { alpha = 0, time = 300, onComplete = 
            function() 
                display.remove(group)
                group = nil
                self._messageCount = self._messageCount - 1

                for i = 1, self._group.numChildren do
                    local group = self._group[i]
                    if group.isMessage then
                        group:translate(0, -self._fontSize * 1.25)
                    end
                end
            end })
    end)
end

function Debug:enable()
    self._enabled = true
    self:__addMonitor()
end

function Debug:disable()
    self._enabled = false
    self:__removeMonitor()
end

function Debug:__addMonitor()
    local background = display.newRect(self._group, 0, 0, display.pixelHeight * 0.125,  display.pixelWidth * 0.15)
    background.anchorX = 0
	background.anchorY = 0
	background:setFillColor( 0 )
    background.alpha = 0.65
    local text = display.newText(
    {
        parent = self._group, 
        text = "", 
        x = background.width / 2, 
        y = background.height / 2, 
        font = native.systemFont, 
        fontSize = self._fontSize, 
        align = "center" 
    })
    text:setFillColor( 1 )
    self._group.monitor = { text = text }
end

function Debug:__removeMonitor()
    for i = self._group.numChildren, 1, -1 do
        self._group[i]:removeSelf()
        self._group[i] = nil
    end
    self._group.monitor = nil
end

return Debug