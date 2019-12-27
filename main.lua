require( "manada.Core" ):initialize( )

local map = manada.Map:new()
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

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

local PhysicsComponent = require( "src.scenes.game.gameObjects.components.PhysicsComponent" )
local AIControlComponent = require( "src.scenes.game.gameObjects.components.controls.AIControlComponent" )
local PlayerControlComponent = require( "src.scenes.game.gameObjects.components.controls.PlayerJoyControlComponent" )
local DisplayComponent = require( "src.scenes.game.gameObjects.components.DisplayComponent" )

local rectangle = manada.ContainerObject:new()
rectangle:add( "display", DisplayComponent, { displayObject = display.newRect(100, 100, 100, 100) } )
local displayObject = rectangle:get( "display" ):getObject()

displayObject:setFillColor( 0, 0, 0 )
group:insert( displayObject )
rectangle:add( "physics", PhysicsComponent )
rectangle:add( "control", PlayerControlComponent )

Runtime:addEventListener( "enterFrame", function ( event )
    
    rectangle:update()

end)

local emitter = addEmitter( "explosion", group )
emitter.x = 300
emitter.y = 600