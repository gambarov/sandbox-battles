local class = require("manada.libs.middleclass")

local Component = class("StatsComponent")

function Component:initialize(gameObject, params)
    -- Статы объекта
    for stat, value in pairs(params) do
        self["_original_" .. stat] = value
        self["_current_" .. stat] = value
    end 
end

function Component:set(name, value)
    self["_current_" .. name] = value
end

function Component:get(name, statType)
    statType = statType or "current"
    return self["_" .. statType .. "_" .. name]
end

function Component:remove(name)
    if self:get(name) then
        self["_original_" .. name] = nil
        self["_current_" .. name] = nil
    end
end

function Component:increase(name, value)
    self:set(name, self:get(name, "current") + value)
end

function Component:decrease(name, value)
    self:increase(name, -value) 
end

function Component:restore(name)
    if self["_current_" .. name] and self["_original_" .. name] then
        self["_current_" .. name] = self["_original_" .. name]
    end
end

function Component:destroy()
    
end

return Component