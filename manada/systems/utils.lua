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

function Utils:getByIndex(table, index)
    local i = 0
    for k, v in pairs(table) do
        if index == i then
            return v
        end
        i = i + 1
    end
    return nil
end

function Utils:deepNumChildren(group)
	local function countChildren(group)
		local count = 1
		if group.numChildren and not group.isMonitor then
			count = count + group.numChildren
			for i = group.numChildren, 1, -1 do
				count = count + countChildren(group[i])
			end
		end
		return count
	end
	return countChildren( group )
end

return Utils
