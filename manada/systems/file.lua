local class = require( "manada.libs.middleclass" )

local File = class ( "File" )

function File:initialize( params )
end

function File:getExtensionFromPath(path)

    local temp = manada.utils:splite(path, ".")
    local ext = temp[#temp]

    return ext

end

return File