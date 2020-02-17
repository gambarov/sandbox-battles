local mainGroup = display.newGroup()

local table = require("src.scenes.game.widgets.ManadaTableView")
local button = require("src.scenes.game.widgets.ManadaButton")

local charactersSheet = manada.isheet:get("characters")
local weaponsSheet = manada.isheet:get("weapons")
local uiSheet = manada.isheet:get("ui")

local currentCharacterFactory

local weaponsTable = table:new({ displayGroup = mainGroup, left = display.pixelHeight - (display.pixelHeight * 0.095 * 3), top = 0 })
weaponsTable:hide(false)

for name, index in pairs(weaponsSheet.info.frameIndex) do
	-- local background = display.newImage(uiSheet.image, uiSheet.info:getFrameIndex("SquareButton"))
	local background = display.newRect(100, 100, 0, 0)
	local icon = display.newImage(weaponsSheet.image, index)
	local onTouchHandler = function()
		currentCharacterFactory.params.weapon = manada:getGameData("weapons")[name] 
		manada:getActiveMap():setTouchHandler("NPCSpawnHandler", { factory = currentCharacterFactory })
		manada.debug:message("Selected weapon \"" .. name .. "\"")
	end

	weaponsTable:insertRow({ icon = icon, background = background }, onTouchHandler)
end

local charactersTable = table:new({ displayGroup = mainGroup, left = display.pixelHeight - (display.pixelHeight * 0.095 * 2), top = 0 })
charactersTable:hide(false)

for name, index in pairs(charactersSheet.info.frameIndex) do
	-- local background = display.newImage(uiSheet.image, uiSheet.info:getFrameIndex("SquareButton"))
	local background = display.newRect(100, 100, 0, 0)
	local icon = display.newImage(charactersSheet.image, index)
	local onTouchHandler = function()
		currentCharacterFactory =
		{
			instance = manada:getFactory("NPCFactory"),
			params = manada:getGameData("characters")[name]
		}
		weaponsTable:show(true)
		manada.debug:message("Selected character \"" .. name .. "\"")
	end

	charactersTable:insertRow({ icon = icon, background = background }, onTouchHandler)
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
			weaponsTable:selectRow(false)
			timer.performWithDelay(200, function()
				charactersTable:selectRow(false) 								-- Сбрасываем текущий выбор
				charactersTable:hide(true) 										-- Прячем 
				manada:getActiveMap():setTouchHandler("ObjectRemoveHandler") 
			end)
		end
	}, 

	{ 
		name = "Exit", 
		handler = function() 
		end 
	},
}

for i = 1, #menuItems, 1 do
	menuTable:insertRow(
		{ 
			icon = display.newText(menuItems[i].name, 0, 0, native.systemFont, display.pixelHeight * 0.095 / 3.5), 
			background = display.newRect(100, 100, 0, 0) 
		}, 
		menuItems[i].handler)
end

return mainGroup