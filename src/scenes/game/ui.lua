-- need sliding panel
local widget = require("widget")

local gameObjectFactory = require("src.scenes.game.gameObjects.factories.NPCFactory"):new()
local barrierFactory = require("src.scenes.game.gameObjects.factories.BarrierFactory"):new()

local uiGroup = display.newGroup()

local xBtn = 0.1 * display.pixelHeight
local yBtn = 0.85 * display.pixelWidth
local widthBtn = 0.15 * display.pixelHeight
local heightBtn = 0.1 * display.pixelWidth
local sizeBtn = (widthBtn + heightBtn) / 2
local offsetBtn = 25

local function addButton(displayGroup, text, x, y, handler)
    -- Create the widget
    local button = widget.newButton(
        {
            label = text,
            onEvent = handler,
            emboss = false,
            -- Properties for a rounded rectangle button
            shape = "roundedRect",
            width = sizeBtn,
            height = sizeBtn,
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
        manada:getActiveMap():setTouchHandler("NPCSpawnHandler", { factory = gameObjectFactory })
    end
end)

addButton(uiGroup, "Spawn block", xBtn + sizeBtn + offsetBtn, yBtn, function (event)
    if event.phase == "ended" then
        manada:getActiveMap():setTouchHandler("BlockSpawnHandler", { factory = barrierFactory })
    end
end)

addButton(uiGroup, "Remove block", xBtn + (sizeBtn * 2) + (offsetBtn * 2), yBtn, function (event)
    if event.phase == "ended" then
        -- manada:getActiveMap():setTouchHandler("BlockRemoveHandler")
        local gameObjs = manada:getGameObjects()

        for i = 1, #gameObjs, 1 do
            if gameObjs[i]:hasComponent("weapon") then
                gameObjs[i]:getVisual():dispatchEvent({ name = "attack" })
            end
        end
    end
end)

return uiGroup