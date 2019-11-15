local class = require( "manada.libs.middleclass" )

-- Объявление класса
local Core = class( "Core" )

-- Сторонние библиотеки для работы
local visualMonitor = require("manada.libs.visualMonitor")

Core.plugins = {}
Core.Debug = true

function Core:initialize( params )

    self._systems = {}

	local loadSystem = function( name, params )
		self[ name ] = require( "manada.systems." .. name ):new( params or {} )
		self._systems[ #self._systems + 1 ] = self[ name ]
    end

    -- Загрузка всех систем
    loadSystem( "utils"  )
    loadSystem( "file"   )
    loadSystem( "sound"  )
    loadSystem( "time"   )
    loadSystem( "plugin" )

    if self.Debug then
        visualMonitor:new()
    end

    display.setStatusBar( display.HiddenStatusBar ) 

end

manada = Core:new()