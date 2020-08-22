require("manada.Core"):initialize()
manada.debug:enable()
-- Activate multitouch
system.activate("multitouch")
-- require("physics").setDrawMode("hybrid")
display.setDefault("magTextureFilter", "nearest")
display.setDefault("minTextureFilter", "nearest")
display.setStatusBar( display.HiddenStatusBar ) 

manada.isheet:add("gameObjects")
manada.isheet:add("ui")
manada.isheet:add("characters")
manada.isheet:add("weapons")

-- Первый запуск приложения 
if manada.data:isEmpty() then
    local defaultData = require("src.defaultData")
    manada.data:set("settings", defaultData.settings)
    manada.data:set("gameObjects", defaultData.gameObjects)
end

-- Кастомные глобальные ф-ции
manada.getFactory = function(self, name)
    local path = "src.scenes.game.gameObjects.factories."
    return require(path .. name)
end

manada.getComponent = function(self, type, name)
    local path = "src.scenes.game.gameObjects.components." .. type .. "."
    return require(path .. name)
end

manada.getMapTouchHandler = function(self, type, name)
    local path = "src.scenes.game.map.touchHandlers." .. type .. "."
    return require(path .. name)
end

manada.getGameData = function(self, name)
    local data = require("src.scenes.game.data")

    if not name then 
        return data
    else
        return data[name]
    end
end

local composer = require("composer")
composer:gotoScene("src.scenes.game")