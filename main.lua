require( "manada.Core" ):initialize( )

local map = manada.Map:new()
local group = map:getGroup()

-- Перемещаем основную группу в центр экрана
group.x, group.y = 0.5 * display.pixelHeight, 0.5 * display.pixelWidth
-- Смещаем ее тоску привязки, чтобы все наэкранные объекты в группе были также в центре
group.anchorChildren = true
group.anchorX = 0.5
group.anchorY = 0.5

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
physics.setGravity(0, 0)

local gameObjectFactory = require("src.scenes.game.gameObjects.factories.TestGOFactory"):new()
manada:addGameObject(gameObjectFactory, { displayObject = display.newRect(group, 100, 100, 100, 100) })