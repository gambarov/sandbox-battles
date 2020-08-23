local class = require("manada.libs.middleclass")

local Factory = class("NPCFactory")

function Factory:create(params)
    -- Ограничение по кол-ву созданий НПС
    if #manada:getGameObjectsByType("npc") >= 25 then
        return false
    end

    -- Спрайт-лист с нпс
    local sheet = manada.isheet:get("characters")
    -- Получаем нужный спрайт
    local visual = display.newImage(params.parent, sheet.image, sheet.info:getFrameIndex(params.name), params.x, params.y)
    -- Создаем объект
    local npc = manada.GameObject:new({ visual = visual, name = params.name or "NPCGameObject", type = "npc" })
    npc:setRotation(manada.random:range(1, 360))

    npc:setComponent("stats",   manada:getComponent("general", "stats"), params.stats or {})
    npc:setComponent("physics", manada:getComponent("npc", "physics"), params.physics)
    npc:setComponent("input",   manada:getComponent("ai", "simple"))
    npc:setComponent("weapon",  manada:getComponent("npc", "weapon"), params.weapon)

    return manada:addGameObject(npc)
end

return Factory