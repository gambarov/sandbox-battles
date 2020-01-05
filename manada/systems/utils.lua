local class = require("manada.libs.middleclass")

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

function Utils:count(table)

    local count = 0

    for k, v in pairs(table) do
        count = count + 1
    end

    return count
end

return Utils
