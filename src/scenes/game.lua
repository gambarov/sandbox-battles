
local composer = require( "composer" )
local physics = require( "physics" )
local gameObjectFactory = require("src.scenes.game.gameObjects.factories.TestGOFactory"):new()
local barrierFactory = require("src.scenes.game.gameObjects.factories.BarrierFactory"):new()

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

physics.start()
physics.setGravity(0, 0)

local map

local masterGroup	-- Главная группа отображения
local bgGroup
local mainGroup		-- Группа отображения карты, игровых объектов и т.д. 
local uiGroup		-- Группа отображения пользовательского интерфейса

local function addGameObjectOnScreen(event)

	local xObjectSpawn, yObjectSpawn = mainGroup:contentToLocal(event.x, event.y)

    -- Если произведено нажатие и пользователь не перемещал карту и точка касания находится внутри карты
	if event.phase == "ended" and event.x == event.xStart and event.y == event.yStart and xObjectSpawn > 0 and yObjectSpawn > 0 and xObjectSpawn < mainGroup.width and yObjectSpawn < mainGroup.height then
		print(xObjectSpawn, yObjectSpawn)
		local mx, my = xObjectSpawn / map:getCellSize(), yObjectSpawn / map:getCellSize()
		mx, my = math.ceil(mx), math.ceil(my)
		manada:addGameObject(barrierFactory, { displayObject = display.newRect(mainGroup, mx * map:getCellSize() - map:getCellSize() / 2, my * map:getCellSize() - map:getCellSize() / 2, map:getCellSize(), map:getCellSize()) })
		manada.camera:add("main", { target = manada:getGameObjects()[1]:getDisplayObject(), parent = mainGroup, speed = 10 })
		return true
	end
end
 

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	physics.pause()

	masterGroup = display.newGroup()
	bgGroup 	= display.newGroup()
	mainGroup 	= display.newGroup()
	uiGroup 	= display.newGroup()

	scene.view:insert(masterGroup)
	masterGroup:insert(bgGroup)
	masterGroup:insert(mainGroup)
	masterGroup:insert(uiGroup)

	map = manada.Map:new({ parent = mainGroup })
	mainGroup = manada.plugin:new(mainGroup, "pinchZoomDrag")

	-- Перемещаем игровую группу в центр экрана
	mainGroup.x, mainGroup.y = math.floor(0.5 * display.pixelHeight), math.floor(0.5 * display.pixelWidth)
	-- Смещаем ее тоску привязки, чтобы все наэкранные объекты в группе были также в центре
	mainGroup.anchorChildren = true
	mainGroup.anchorX = 0.5
	mainGroup.anchorY = 0.5

	local bg = display.newRect(bgGroup, display.pixelHeight / 2, display.pixelWidth / 2, display.pixelHeight, display.pixelWidth)
	bg:setFillColor({ 1, 1, 1 })
	bg:addEventListener("touch", function (event)
		return mainGroup:touch(event)
	end)
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		physics.start()
		mainGroup:addEventListener("touch", addGameObjectOnScreen)
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
