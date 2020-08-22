local class = require("manada.libs.middleclass")

local widget = require("widget")

local Widget = class("GameObjectTableView")

local colors = {
    rowColor = { default = { 0, 0, 0, 0 }, over = { 0, 0, 0, 0 } },
    rowBackground = { default = { 100/255, 100/255, 135/255, 1 }, selected = { 220/255, 200/255, 110/255, 0.5 } }
}

local tableWidth = display.pixelHeight * 0.095

function Widget:initialize(params)
    self._tables = {}
    self._left = params.left
    self._top = params.top
end

function Widget:add(name, table)
end

function Widget:get(name)
    
end

function Widget:show(name)
end

function Widget:hide(name)
    
end

return Widget