require( "manada.core" )

local map = require( "manada.map" ):new();
local group = map:getGroup()
group.x, group.y = display.contentCenterX - group.width / 2, display.contentCenterY - group.height / 2

local json = require( "json" )

local function addEmitter(particleName, group)

    local path = "res\\particles\\" .. particleName .. "\\particle_texture";

    local f = io.open( system.pathForFile(path .. ".json"), "r" )
    local emitterData = f:read( "*a" )
    f:close()

    local emitterParams = json.decode( emitterData )
    emitterParams.textureFileName = path .. ".png"

    local emitter = display.newEmitter( emitterParams )
    
    if group then
        group:insert(emitter)
        emitter.absolutePosition = group
    end

    return emitter

end