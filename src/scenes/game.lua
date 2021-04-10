local composer = require("composer")
physics = require("physics")

local scene = composer.newScene()

physics.start()
physics.setGravity(0, 0)

local masterGroup	-- Главная группа отображения
local bgGroup		-- Группа отображения заднего фона
local mainGroup		-- Группа отображения карты, игровых объектов и т.д. 
local uiGroup		-- Группа отображения пользовательского интерфейса

function scene:create( event )

	physics.pause()

	masterGroup = display.newGroup()
	bgGroup 	= display.newGroup()
	mainGroup 	= display.newGroup()
	uiGroup 	= require("src.scenes.game.ui")

	scene.view:insert(masterGroup)
	masterGroup:insert(bgGroup)
	masterGroup:insert(mainGroup)
	masterGroup:insert(uiGroup)

	manada:setGameMap(manada.Map:new({ generator = "simple", group = mainGroup, width = 10, height = 15, cellSize = 256 }))

	-- Перемещаем игровую группу в центр экрана
	mainGroup.x, mainGroup.y = math.floor(0.5 * display.pixelHeight), math.floor(0.5 * display.pixelWidth)
	-- Смещаем ее тоску привязки, чтобы все наэкранные объекты в группе были также в центре
	mainGroup.anchorChildren = true
	mainGroup.anchorX = 0.5
	mainGroup.anchorY = 0.5
	mainGroup:scale(0.5, 0.5)
end


function scene:show( event )

	local sceneGroup = self.view

	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		physics.start()

		mainGroup = manada.plugin:new(mainGroup, "pinchZoomDrag", 
		{ 
			background = 
			{
				parent = bgGroup,
				isheetName = "gameObjects",
				isheetIndexFrame = "Terrain1",
				fillColor = { 45/255, 45/255, 55/255, 0.75 }
			}
		})
	end
end


function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	physics.stop()
	physics = nil

end


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
