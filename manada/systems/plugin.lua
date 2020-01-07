local class = require( "manada.libs.middleclass" )

local Plugin = class( "Plugin" )

function Plugin:initialize( params )    
    self._path = params.path or "manada.plugins."
end

function Plugin:new( instance, name, params )
    local plugin = require( self._path .. name )
    instance = plugin:new(instance, params or {})
    return instance
end

return Plugin