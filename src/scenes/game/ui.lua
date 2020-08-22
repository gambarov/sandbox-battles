local mainGroup = display.newGroup()

local table = require("src.scenes.game.widgets.ManadaTableView")

local charactersSheet = manada.isheet:get("characters")
local weaponsSheet = manada.isheet:get("weapons")
local uiSheet = manada.isheet:get("ui")

local weaponsTable = table:new({ displayGroup = mainGroup, left = display.pixelHeight - (display.pixelHeight * 0.095 * 3), top = 0 })
weaponsTable:hide(false)

for name, index in pairs(weaponsSheet.info.frameIndex) do
	weaponsTable:insertRow(name,
		{ 
			icon = display.newImage(weaponsSheet.image, index), 
			background =  display.newImage(uiSheet.image, uiSheet.info:getFrameIndex("SquareButtonBG")) 
		}, 
		function()
			-- Запоминаем выбор оружия
			manada.data:set("weaponToSpawn", name)
		end)
end


local charactersTable = table:new({ displayGroup = mainGroup, left = display.pixelHeight - (display.pixelHeight * 0.095 * 2), top = 0 })
charactersTable:hide(false)

for name, index in pairs(charactersSheet.info.frameIndex) do
	charactersTable:insertRow(name,
		{ 
			icon = display.newImage(charactersSheet.image, index), 
			background = display.newImage(uiSheet.image, uiSheet.info:getFrameIndex("SquareButtonBG")) 
		}, 
		function()
			-- Запоминаем выбор нпс
			manada.data:set("npcToSpawn", name)
			-- Если оружие еще не было выбрано
			if not manada.data:get("weaponToSpawn") then
				manada.data:set("weaponToSpawn", "Shotgun")	-- Выбор оружия по-умолчанию
				weaponsTable:highlightRow("Shotgun")		-- Подсвечиваем данную строку в таблице выбора оружия
			else
			-- Какое-то оружие уже выбрано, подсвечиваем выбор
				weaponsTable:highlightRow(manada.data:get("weaponToSpawn"))
			end
			-- Текущий обработчик нажатий по карте - спавн нпс
			manada:getActiveMap():setTouchHandler("spawn", "npc")
			-- После выбора нпс, показываем меню с выбором оружия
			weaponsTable:show(true)
		end)
end


local menuTable = table:new({ displayGroup = mainGroup, left = display.pixelHeight - display.pixelHeight * 0.095, top = 0 })

local menuItems = 
{ 
	{ 
		name = "Sandbox",  
		handler = function() 
			manada:resume()
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
				manada:getActiveMap():setTouchHandler("object", "remove") 
			end)
		end
	}, 

	{ 
		name = "Pause", 
		handler = function()
			manada:pause() 
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