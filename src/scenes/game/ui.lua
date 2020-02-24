local mainGroup = display.newGroup()

local table = require("src.scenes.game.widgets.ManadaTableView")

local charactersSheet = manada.isheet:get("characters")
local weaponsSheet = manada.isheet:get("weapons")
local uiSheet = manada.isheet:get("ui")

local currentCharacterFactory = {}

local weaponsTable = table:new({ displayGroup = mainGroup, left = display.pixelHeight - (display.pixelHeight * 0.095 * 3), top = 0 })
weaponsTable:hide(false)

for name, index in pairs(weaponsSheet.info.frameIndex) do
	weaponsTable:insertRow(
		{ 
			icon = display.newImage(weaponsSheet.image, index), 
			background =  display.newImage(uiSheet.image, uiSheet.info:getFrameIndex("SquareButtonBG")) 
		}, 
		function()
			currentCharacterFactory.params.weapon = manada:getGameData("weapons")[name] 
			manada:getActiveMap():setTouchHandler("NPCSpawnHandler", { factory = currentCharacterFactory })
		end)
end


local charactersTable = table:new({ displayGroup = mainGroup, left = display.pixelHeight - (display.pixelHeight * 0.095 * 2), top = 0 })
charactersTable:hide(false)

for name, index in pairs(charactersSheet.info.frameIndex) do
	charactersTable:insertRow(
		{ 
			icon = display.newImage(charactersSheet.image, index), 
			background = display.newImage(uiSheet.image, uiSheet.info:getFrameIndex("SquareButtonBG")) 
		}, 
		function()
			currentCharacterFactory.instance = manada:getFactory("NPCFactory")
			currentCharacterFactory.params = manada:getGameData("characters")[name]
			manada:getActiveMap():removeTouchHandler()
			-- При выборе персонажа, показываем меню с выбором оружия
			weaponsTable:show(true)
			-- Сбрасываем прошлый выбор, если имеется
			weaponsTable:resetHighlight()
		end)
end


local menuTable = table:new({ displayGroup = mainGroup, left = display.pixelHeight - display.pixelHeight * 0.095, top = 0 })

local menuItems = 
{ 
	{ 
		name = "Sandbox",  
		handler = function() 
			charactersTable:show(true)
		end
	}, 

	{ 
		name = "Remove", 
		handler = function() 
			
			weaponsTable:hide(true)
			weaponsTable:resetHighlight()

			timer.performWithDelay(100, function()
				charactersTable:resetHighlight()								-- Сбрасываем текущий выбор
				charactersTable:hide(true) 										-- Прячем 
				manada:getActiveMap():setTouchHandler("ObjectRemoveHandler") 
			end)
		end
	}, 

	{ 
		name = "Exit", 
		handler = function() 
			manada:getActiveMap():removeTouchHandler()
		end 
	},
}

for i = 1, #menuItems, 1 do
	menuTable:insertRow(
		{ 
			icon = display.newText(menuItems[i].name, 0, 0, native.systemFont, display.pixelHeight * 0.095 / 3.8), 
			background = display.newImage(uiSheet.image, uiSheet.info:getFrameIndex("SquareButtonBG")) 
		}, 
		menuItems[i].handler)
end

return mainGroup