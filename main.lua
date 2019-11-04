require('manada.core')
require('puggle.core')

manada.test:testPrint()

local map = require('manada.map'):new({ cellSize = 128, height = 18 });
local group = map:getGroup()
group.x, group.y = display.contentCenterX - group.width / 2, display.contentCenterY - group.height / 2