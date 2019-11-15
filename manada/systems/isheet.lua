local class = require( "manada.libs.middleclass" )

local ISheet = class( "ISheet" )

function ISheet:initialize( params )
    
    self._isheets = {}

end

function ISheet:add( name )
    
end

function ISheet:remove( name )
    
    if self:get( name ) then
        self._isheets[ name ] = nil
        return true
    end

    return false

end

function ISheet:get( name )

    local isheet = self._isheets[ name ]

    if not isheet then
        print( "WARNING: " .. "Can't get image sheet \"" .. name .. "\" because it's dont exist" )
    end

    return isheet

end

function ISheet:destroy()

    self._isheets = nil
    
end

return ISheet