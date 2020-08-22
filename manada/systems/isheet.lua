local class = require("manada.libs.middleclass")

local ISheet = class("ISheet")

ISheet.SheetsInfoPath = "res.sheets."
ISheet.SheetsImagePath = "res/sheets/"

function ISheet:initialize(params)
    self._isheets = {}
end

function ISheet:add(name)
    -- Данные об атласе и его изображение
    local sheetInfo = require(self.SheetsInfoPath .. name) 
    local sheetImage = graphics.newImageSheet(self.SheetsImagePath .. name .. ".png", sheetInfo:getSheet())
    -- Сохраняем в массиве атласов
    self._isheets[name] = { info = sheetInfo, image = sheetImage }
end

function ISheet:remove(name)
    
    if self:get( name ) then
        self._isheets[ name ] = nil
        return true
    end

    return false
end

function ISheet:get(name)

    local isheet = self._isheets[ name ]

    if not isheet then
        print("WARNING: " .. "Can't get image sheet \"" .. name .. "\" because it's dont exist")
    end

    return isheet
end

function ISheet:destroy()

    for name, _ in pairs(self._isheets) do
        self:remove(name)
    end

    self._isheets = nil
end

return ISheet