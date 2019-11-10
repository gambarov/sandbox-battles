local class = require("manada.exts.middleclass")

local Utils = class("Utils")

function Utils:splite(str, delimeter)

    delimeter = delimeter or "%s"

    local t = {}

    for field, s in string.gmatch(str, "([^" .. delimeter .. "]*)(" .. delimeter .. "?)") do
        table.insert(t, field)
        
        if s == "" then
            return t
        end
    end

end

return Utils
