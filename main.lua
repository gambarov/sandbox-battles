require( "manada.Core" ):initialize( )

local map = manada.Map:new()
local masterGroup = map:getGroup()

-- Перемещаем основную группу в центр экрана
masterGroup.x, masterGroup.y = math.floor(0.5 * display.pixelHeight), math.floor(0.5 * display.pixelWidth)
-- Смещаем ее тоску привязки, чтобы все наэкранные объекты в группе были также в центре
masterGroup.anchorChildren = true
masterGroup.anchorX = 0.5
masterGroup.anchorY = 0.5

local json = require( "json" )

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

local physics = require( "physics" )
physics.start()
physics.setGravity(0, 0)

local gameObjectFactory = require("src.scenes.game.gameObjects.factories.TestGOFactory"):new()

local function addGameObjectOnScreen(event)
    -- Если произведено нажатие и пользователь не перемещал карту
    if event.phase == "ended" and event.x == event.xStart and event.y == event.yStart then
        local x, y = masterGroup:contentToLocal(event.x, event.y)
        manada:addGameObject(gameObjectFactory, { displayObject = display.newRect(masterGroup, x, y, 128, 128) })
    end

end

masterGroup:addEventListener("touch", addGameObjectOnScreen)
