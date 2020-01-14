
local composer = require( "composer" )
local physics = require( "physics" )


local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

physics.start()
physics.setGravity(0, 0)

local masterGroup	-- Главная группа отображения
local bgGroup		-- Группа отображения заднего фона
local mainGroup		-- Группа отображения карты, игровых объектов и т.д. 
local uiGroup		-- Группа отображения пользовательского интерфейса

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

	manada.isheet:add("gameObjects")

	manada:setActiveMap(manada.Map:new({ generator = "simple", parent = mainGroup, width = 10, height = 15, cellSize = 256 }))
	mainGroup:scale(0.25, 0.25)
	uiGroup = require("src.scenes.game.ui")

	-- Перемещаем игровую группу в центр экрана
	mainGroup.x, mainGroup.y = math.floor(0.5 * display.pixelHeight), math.floor(0.5 * display.pixelWidth)
	-- Смещаем ее тоску привязки, чтобы все наэкранные объекты в группе были также в центре
	mainGroup.anchorChildren = true
	mainGroup.anchorX = 0.5
	mainGroup.anchorY = 0.5

	local bg = display.newRect(bgGroup, display.pixelHeight / 2, display.pixelWidth / 2, display.pixelHeight, display.pixelWidth)
	bg:setFillColor({ 1, 1, 1 })
	bg:addEventListener("touch", function (event)
		if mainGroup["touch"] then
			return mainGroup:touch(event)
		end
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
		mainGroup = manada.plugin:new(mainGroup, "pinchZoomDrag")
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
