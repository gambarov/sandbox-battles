local gameObjectFactory = require("src.scenes.game.gameObjects.factories.NPCFactory"):new()
local barrierFactory = require("src.scenes.game.gameObjects.factories.BarrierFactory"):new()

local mainGroup = display.newGroup()
local tableGroup = display.newGroup()

local gameObjectTable = require("src.scenes.game.widgets.gameObjectTableView")
local button = require("src.scenes.game.widgets.button")

local mainTable = gameObjectTable:new({ displayGroup = mainGroup })
mainTable:insertRow("Soldier", "NPCSpawnHandler", gameObjectFactory)
mainTable:insertRow("BlockBox1", "BlockSpawnHandler", barrierFactory)

local removeBtn = button:new(
	{ 
		displayGroup = mainGroup,
		text = "REMOVE", 
		x = 0.055 * display.pixelHeight, 
		y = 0.9 * display.pixelWidth, 
		width = 0.085 * display.pixelHeight, 
		height = 0.085 * display.pixelHeight, 
		handler = 
		function (event)
			if event.phase == "ended" then
				mainTable:selectRow(false)
				manada:getActiveMap():setTouchHandler("ObjectRemoveHandler")
			end
		end 
	})
	
return mainGroup