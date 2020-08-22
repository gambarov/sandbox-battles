local class = require("manada.libs.middleclass")

local Handler = class("NPCSpawnHandler")

local factory = manada:getFactory("npc")

local ceil = math.ceil

function Handler:initialize(params)
end

function Handler:handle(touch)

    local map = manada:getActiveMap()
    local i, j = ceil(touch.y / map:getCellSize()), ceil(touch.x / map:getCellSize())
    local cell = map:getCell(i, j)
        
    if cell and cell.type and cell.type == "free" then
        -- Получаем данные о нпс, родителе и месте спавна
        local params = manada:getGameData("characters")[manada.data:get("npcToSpawn")]
        params.weapon = manada:getGameData("weapons")[manada.data:get("weaponToSpawn")]
        params.parent = map:getDisplayGroup()
        params.x = touch.x
        params.y = touch.y
        return factory:create(params)
    end
end

return Handler
