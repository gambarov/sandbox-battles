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

local gameObjects = {}

local function createGameObject()
    local gameObject = manada.ContainerObject:new()
    gameObject:add( "display", DisplayComponent, { displayObject = display.newRect(math.random(100, 700), math.random(100, 700), 100, 100)  } )
    local displayObject = gameObject:get( "display" ):getObject()

    displayObject:setFillColor( 0, 0, 0 )
    group:insert( displayObject )
    gameObject:add( "physics", PhysicsComponent )
    gameObject:add( "control", AIControlComponent )

    return gameObject
end

Runtime:addEventListener( "enterFrame", function ( event )
    
    for i = #gameObjects, 1, -1 do
        if gameObjects[i] then
            gameObjects[i]:update(manada.time:delta())
        end
    end

end)

timer.performWithDelay(1000, 
function()
    gameObjects[#gameObjects+1] = createGameObject()
end, -1)

timer.performWithDelay(2000, 
function() 
    if gameObjects[1] then
        gameObjects[1]:destroy()
        gameObjects[1] = nil
    end
end, -1)