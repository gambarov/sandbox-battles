require( "manada.Core" ):initialize( )
manada.debug:enable()

local json = require( "json" )
local composer = require("composer")

local function addEmitter(particleName, masterGroup)

    local path = "res\\particles\\" .. particleName .. "\\particle_texture";

    local f = io.open( system.pathForFile(path .. ".json"), "r" )
    local emitterData = f:read( "*a" )
    f:close()

    local emitterParams = json.decode( emitterData )
    emitterParams.textureFileName = path .. ".png"

    local emitter = display.newEmitter( emitterParams )
    
    if masterGroup then
        masterGroup:insert(emitter)
        emitter.absolutePosition = masterGroup
    end

    return emitter

end

-- Activate multitouch
system.activate( "multitouch" )

display.setDefault("magTextureFilter", "nearest")
display.setDefault("minTextureFilter", "nearest")
display.setStatusBar( display.HiddenStatusBar ) 

-- Первый запуск приложения 
if manada.data:empty() then
    local defaultData = require("src.defaultData")
    manada.data:set("settings", defaultData.settings)
    manada.data:set("gameObjects", defaultData.gameObjects)
end

composer:gotoScene("src.scenes.game")