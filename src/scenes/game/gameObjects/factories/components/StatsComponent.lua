local class = require("manada.libs.middleclass")

local Component = class("StatsComponent")

function Component:initialize(params)

    for stat, value in pairs(params) do
        self["_" .. stat] = value
    end 

end

function Component:set(name, value)
    self["_" .. name] = value
end

function Component:get(name)
    return self["_" .. name]
end

return Component