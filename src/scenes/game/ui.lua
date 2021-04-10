local mainGroup = display.newGroup()

local table = require("src.scenes.game.widgets.ManadaTableView")

local npcSheet = manada.isheet:get("characters")
local weaponSheet = manada.isheet:get("weapons")
local uiSheet = manada.isheet:get("ui")

local weaponTable = table:new({ displayGroup = mainGroup, left = display.pixelHeight - (display.pixelHeight * 0.095 * 3), top = 0 })
weaponTable:hide(false)

for name, index in pairs(weaponSheet.info.frameIndex) do
	weaponTable:insertRow(name,
		{ 
			icon = display.newImage(weaponSheet.image, index), 
			background =  display.newImage(uiSheet.image, uiSheet.info:getFrameIndex("SquareButtonBG")) 
		}, 
		function()
			-- Запоминаем выбор оружия
			manada.data:set("weaponToSpawn", name)
		end)
end


local npcTable = table:new({ displayGroup = mainGroup, left = display.pixelHeight - (display.pixelHeight * 0.095 * 2), top = 0 })
npcTable:hide(false)

for name, index in pairs(npcSheet.info.frameIndex) do
	npcTable:insertRow(name,
		{ 
			icon = display.newImage(npcSheet.image, index), 
			background = display.newImage(uiSheet.image, uiSheet.info:getFrameIndex("SquareButtonBG")) 
		}, 
		function()
			-- Запоминаем выбор нпс
			manada.data:set("npcToSpawn", name)
			-- Если оружие еще не было выбрано
			if not manada.data:get("weaponToSpawn") then
				manada.data:set("weaponToSpawn", "Shotgun")	-- Выбор оружия по-умолчанию
				weaponTable:highlightRow("Shotgun")			-- Подсвечиваем данную строку в таблице выбора оружия
			-- Какое-то оружие уже выбрано, подсвечиваем выбор
			else
				weaponTable:highlightRow(manada.data:get("weaponToSpawn"))
			end
			-- Текущий обработчик нажатий по карте - спавн нпс
			manada:getGameMap():setTouchHandler("spawn", "npc")
			-- После выбора нпс, показываем меню с выбором оружия
			weaponTable:show(true)
		end)
end


local menuTable = table:new({ displayGroup = mainGroup, left = display.pixelHeight - display.pixelHeight * 0.095, top = 0 })

local menuItems = 
{ 
	{ 
		name = "Sandbox",  
		handler = function() 
			npcTable:show(true)
			-- Текущий обработчик нажатий по карте - спавн нпс
			manada.data:set("terrainToSpawn", "Barrier")
			manada:getGameMap():setTouchHandler("spawn", "barrier")
		end
	}, 

	{ 
		name = "Remove", 
		handler = function() 
			
			weaponTable:hide(true)
			weaponTable:resetHighlight()

			timer.performWithDelay(100, function()
				npcTable:resetHighlight()								-- Сбрасываем текущий выбор
				npcTable:hide(true) 										-- Прячем 
				manada:getGameMap():setTouchHandler("object", "remove") 
			end)
		end
	}, 

	{ 
		name = "Pause", 
		handler = function(row)
			
			if manada:isPaused() then
				row.params.visual.icon.text = "Pause"
			else
				row.params.visual.icon.text = "Resume"
			end 

			manada:togglePause()
			menuTable:highlightRow(false)
		end 
	},
}

for i = 1, #menuItems, 1 do
	menuTable:insertRow(menuItems[i].name,
		{ 
			icon = display.newText(menuItems[i].name, 0, 0, native.systemFont, display.pixelHeight * 0.095 / 3.8), 
			background = display.newImage(uiSheet.image, uiSheet.info:getFrameIndex("SquareButtonBG")) 
		}, 
		menuItems[i].handler)
end

return mainGroup