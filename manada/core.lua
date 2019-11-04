local class = require('manada.exts.middleclass')

local Core = class( 'Core' )

function Core:initialize( params )

    self._systems = {}

    -- Load a system.
	local loadSystem = function( name )
		self[ name ] = require( "manada.systems." .. name ):new()
		self._systems[ #self._systems + 1 ] = self[ name ]
    end
    
    loadSystem('test');

end

manada = Core:new()