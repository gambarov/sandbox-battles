local class = require( "manada.libs.middleclass" )

local Plugin = class( "Plugin" )

function Plugin:initialize( params )    
end

function Plugin:new( instance, name )

    local plugin = require( "manada.plugins." .. name )

    instance = plugin:new(instance)

    return instance
    
end

return Plugin