local class = require("manada.libs.middleclass")

local Factory = class("NPCFactory")

function Factory:create(params)
    -- Спрайт-лист с нпс
    local sheet = manada.isheet:get("characters")
    -- Получаем нужный спрайт
    local visual = display.newImage(params.parent, sheet.image, sheet.info:getFrameIndex(params.name), params.x, params.y)
    -- Создаем объект
    local npc = manada.GameObject:new({ visual = visual, name = params.name or "NPCGameObject" })

    npc:setComponent("physics", manada:getComponent("PhysicsComponent"), params.physics)
    npc:setComponent("input",   manada:getComponent("AIComponent"))
    npc:setComponent("stats",   manada:getComponent("StatsComponent"), params.stats or {})
    npc:setComponent("weapon",  manada:getComponent("WeaponComponent"), params.weapon)
    return npc
end

return Factory