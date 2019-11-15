require( "manada.core" ):initialize(  )

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

local params = 
{
    visual = display.newRect(100, 100, 100, 100),
}

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

local GameObject = require( "src.scenes.game.gameObjects.gameObject" )

local PhysicsComponent = require( "src.scenes.game.gameObjects.components.physicsComponent" )
local AIControlComponent = require( "src.scenes.game.gameObjects.components.controls.AIControlComponent" )

local rectangle = GameObject:new( params )
rectangle:getVisual():setFillColor( 0, 0, 0 )
group:insert( rectangle:getVisual() )
rectangle:addComponent( "physics", PhysicsComponent )
rectangle:addComponent( "control", AIControlComponent )

Runtime:addEventListener( "enterFrame", function ( event )
    
    rectangle:update()

end)