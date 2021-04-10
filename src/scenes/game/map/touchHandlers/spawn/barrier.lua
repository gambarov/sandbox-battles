local class = require("manada.libs.middleclass")

local Handler = class("BarrierSpawnHandler")

local factory = manada:getFactory("barrier")

local ceil = math.ceil

function Handler:initialize(params)
end

function Handler:handle(touch)

    local map = touch.map
    local cell = touch.cell
    -- Преобразуем коорднаты точки касания в точные коорднаты клетки, которую коснулись
    local x, y = map:toCellPos(touch.x, touch.y)
    
    -- Если клетка не занята, то спавним блок и занимаем клетку
    if cell and cell.type and cell.type == "free" then
        map:setCell(touch.line, touch.column, { type = "barrier" })
        print("terrainToSpawn: " .. manada.data:get("terrainToSpawn"))
        local params = manada:getGameData("terrains")[manada.data:get("terrainToSpawn") or "Barrier"]
        params.group = map:getDisplayGroup()
        params.x = x
        params.y = y
        factory:create(params)
    end

    return true
end

return Handler