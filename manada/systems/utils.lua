local class = require("manada.libs.middleclass")

local Utils = class("Utils")

local uudid = require("manada.libs.uuid4")

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

function Utils:countTable(table)
    local count = 0
    for k, v in pairs(table) do
        count = count + 1
    end
    return count
end

function Utils:byIndex(table, index)
    local i = 1
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

function Utils:printTable(table, stringPrefix)
    if not stringPrefix then
       stringPrefix = "### "
    end
    if type( table ) == "table" then
       for key, value in pairs(table) do
          if type( value ) == "table" then
             print( stringPrefix .. tostring( key ) )
             print( stringPrefix .. "{" )
             self:printTable( value, stringPrefix .. "   " )
             print( stringPrefix .. "}" )
          else
             print( stringPrefix .. tostring( key ) .. ": " .. tostring( value ) )
          end
       end
    end
end

function Utils:generateUUID()
	return uudid:getUUID()
end

return Utils
