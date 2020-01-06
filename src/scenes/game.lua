
local composer = require( "composer" )
local physics = require( "physics" )
local gameObjectFactory = require("src.scenes.game.gameObjects.factories.TestGOFactory"):new()

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

physics.start()
physics.setGravity(0, 0)

local map

local masterGroup	-- Главная группа отображения
local mainGroup		-- Группа отображения карты, игровых объектов и т.д. 
local uiGroup		-- Группа отображения пользовательского интерфейса

local function addGameObjectOnScreen(event)
    -- Если произведено нажатие и пользователь не перемещал карту
    if event.phase == "ended" and event.x == event.xStart and event.y == event.yStart then
        local x, y = mainGroup:contentToLocal(event.x, event.y)
		manada:addGameObject(gameObjectFactory, { displayObject = display.newRect(mainGroup, x, y, 128, 128) })
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
	mainGroup = display.newGroup()
	uiGroup = display.newGroup()

	scene.view:insert(masterGroup)

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
