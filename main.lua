require( "manada.core" )

local map = require( "manada.map" ):new();
local group = map:getGroup()
group.x, group.y = display.contentCenterX - group.width / 2, display.contentCenterY - group.height / 2

local json = require( "json" )

local function getEmitter(particleName, group)

    local path = "res\\particles\\" .. particleName .. "\\particle_texture";

    local f = io.open( system.pathForFile(path .. ".json"), "r" )
    local emitterData = f:read( "*a" )
    f:close()

    local emitterParams = json.decode( emitterData )
    emitterParams.textureFileName = path .. ".png"

    local emitter = display.newEmitter( emitterParams )

    if group then
        group:insert(emitter)
    end

    return emitter

end

for i = 1, 10 do

    local emitter = getEmitter( "explosion", map:getGroup() )
   
    emitter.x = math.random( 0, display.contentWidth )
    emitter.y = math.random( 0, display.contentHeight )

end

timer.performWithDelay(1500, function ()
    
    display.remove(map:getGroup())
    map = nil

end, 1)