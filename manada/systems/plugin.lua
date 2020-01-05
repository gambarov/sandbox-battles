local class = require( "manada.libs.middleclass" )

local Plugin = class( "Plugin" )

function Plugin:initialize( params )    
end

function Plugin:new( instance, name, params )

    local plugin = require( "manada.plugins." .. name )

    instance = plugin:new(instance, params or {})

    return instance
    
end

return Plugin