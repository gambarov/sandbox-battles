require( "manada.Core" ):initialize( )

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
display.setStatusBar( display.HiddenStatusBar ) 

manada.data:set("settings", 
{
    soundVolume = 100,
    soundOn = true
})

manada.data:set("objects", 
{
    { name = "human", health = 100, damage = 15 }
})

composer:gotoScene("src.scenes.game")