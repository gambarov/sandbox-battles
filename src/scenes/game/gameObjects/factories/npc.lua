local class = require("manada.libs.middleclass")

local Factory = class("NPCFactory")

function Factory:create(params)
    -- Ограничение по кол-ву созданий НПС
    if #manada:getGameObjectsByType("npc") >= manada:getGameMap():getMaxNPCCount() then
        return false
    end

    -- Спрайт-лист с нпс
    local sheet = manada.isheet:get("characters")
    -- Получаем нужный спрайт
    local visual = display.newImage(sheet.image, sheet.info:getFrameIndex(params.name), params.x, params.y)
    -- Создаем объект
    local npc = manada.GameObject:new({ parentGroup = params.parentGroup, localGroup = params.localGroup or display.newGroup(), visual = visual, name = params.name or "NPCGameObject", type = "npc" })

    npc:setRotation(manada.random:range(1, 360))
    npc:setComponent("stats",     manada:getComponent("general", "stats"), params.stats or {})
    npc:setComponent("physics",   manada:getComponent("npc", "physics"), params.physics)
    npc:setComponent("input",     manada:getComponent("ai", "simple"))
    npc:setComponent("weapon",    manada:getComponent("weapon", params.weapon.type), params.weapon)
    npc:setComponent("healthbar", manada:getComponent("npc", "healthbar"))
    
    return npc
end

return Factory