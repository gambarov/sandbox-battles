-- need sliding panel
local widget = require("widget")

local gameObjectFactory = require("src.scenes.game.gameObjects.factories.TestGOFactory"):new()
local barrierFactory = require("src.scenes.game.gameObjects.factories.BarrierFactory"):new()

local uiGroup = display.newGroup()

local xBtn = 0.1 * display.pixelHeight
local yBtn = 0.9 * display.pixelWidth
local widthBtn = 0.15 * display.pixelHeight
local heightBtn = 0.1 * display.pixelWidth
local offsetBtn = 15

local function addButton(displayGroup, text, x, y, handler)
    -- Create the widget
    local button = widget.newButton(
        {
            label = text,
            onEvent = handler,
            emboss = false,
            -- Properties for a rounded rectangle button
            shape = "roundedRect",
            width = widthBtn,
            height = heightBtn,
            cornerRadius = 2,
            fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
            strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
            strokeWidth = 4
        }
    )

    button.x, button.y = x, y
    displayGroup:insert(button)
end

addButton(uiGroup, "Spawn characters", xBtn, yBtn, function (event)
    if event.phase == "ended" then
        manada:getActiveMap():setTouchHandler("characterSpawnHandler", { factory = gameObjectFactory })
    end
end)

addButton(uiGroup, "Spawn block", xBtn+ widthBtn + offsetBtn, yBtn, function (event)
    if event.phase == "ended" then
        manada:getActiveMap():setTouchHandler("blockSpawnHandler", { factory = barrierFactory })
    end
end)

addButton(uiGroup, "Remove block", xBtn + (widthBtn * 2) + (offsetBtn * 2), yBtn, function (event)
    if event.phase == "ended" then
        manada:getActiveMap():setTouchHandler("blockRemoveHandler")
    end
end)

return uiGroup