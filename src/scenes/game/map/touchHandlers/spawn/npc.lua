local class = require("manada.libs.middleclass")

local Handler = class("NPCSpawnHandler")

local factory = manada:getFactory("npc")

local ceil = math.ceil

function Handler:initialize(params)
end

function Handler:handle(touch)

    local map = touch.map
    local cell = touch.cell

    if map then
        -- Если место под спавн не занято каким-либо барьером
        if cell and cell.type and cell.type == "free" then
            -- Получаем данные о нпс, родителе и месте спавна
            local params = manada:getGameData("npcs")[manada.data:get("npcToSpawn")]
            params.weapon = manada:getGameData("weapons")[manada.data:get("weaponToSpawn")]
            params.parentGroup = map:getDisplayGroup()
            params.x = touch.x
            params.y = touch.y
            return factory:create(params)
        end
    end

    return true
end

return Handler
