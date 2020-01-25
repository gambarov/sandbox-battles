local class = require("manada.libs.middleclass")

local widget = require("widget")

local Widget = class("GameObjectTableView")

local min, max = math.min, math.max

-- Set color variables depending on theme
local colors = {
    rowColor = { default = { 0, 0, 0, 0 }, over = { 0, 0, 0, 0 } },
    rowBackground = { default = { 150/255, 150/255, 150/255, 0.5 }, selected = { 220/255, 200/255, 110/255, 0.5 } }
}

local rowSize = display.pixelHeight * 0.095

function Widget:initialize(params)
    self._group = params.displayGroup
    self._state = "show"

    -- Forward reference for the tableView
    local tableView

    -- Handle row rendering
    local function onRowRender( event )
        local row = event.row
        local bg = row.params.visual.background
        local obj = row.params.visual.gameObject

        row:insert(bg)
        row:insert(obj)
        bg.xScale, bg.yScale = 0.75, 0.75
        obj.width, obj.height = rowSize * 0.5, rowSize * 0.5
        bg:setFillColor(unpack(colors.rowBackground.default))
        bg.stroke = { 25/255, 25/255, 25/255, 0.75 }
        bg.strokeWidth = 6
    end

    local function onRowTouch( event )
        if (event.phase == "release") then
            self:selectRow(event.target)
        end
    end

    local function onTableListener( event )
        
        for k, v in pairs(event) do
            print(k, v)
        end

        print("---------------")

        if event.phase == "began" then

            self._isFocus = true
            self._dragMarkX = self._tableView.x

        elseif self._isFocus then

            if event.phase == "moved" then

                self:selectRow(false)
                self._tableView.x = event.x - event.xStart + self._dragMarkX
                self._tableView.x = max(self._tableView.x, display.pixelHeight - (rowSize / 2))
                self._tableView.x = min(self._tableView.x, display.pixelHeight)

            elseif event.phase == "ended" or event.phase == "stopped" then

                self._isFocus = nil
                self._dragMarkX = nil
            end
        end

        return true
    end

    tableView = widget.newTableView
    {
        top = 0,
        left = display.pixelHeight - (rowSize),
        width = rowSize, 
        height = display.pixelWidth,
        rowTouchDelay = 5,
        noLines = true,
        hideBackground = false,
        backgroundColor = { 65 / 255, 65 / 255, 65 / 255, 1 },
        onRowRender = onRowRender,
        onRowTouch = onRowTouch,
    }

    self._group:insert(tableView)
    self._tableView = tableView
end

function Widget:insertRow(objectName, touchHandlerName, factory)

	local sheet = manada.isheet:get("gameObjects")

	self._tableView:insertRow
	{
		isCategory = false,
		rowHeight = rowSize,
		rowColor = {
			default = colors.rowColor.default,
			over = colors.rowColor.over
		},
		params = 
		{ 
			name = objectName, 
			handler = { name = touchHandlerName, factory = factory }, 
			visual = 
			{ 
				gameObject = display.newImage(sheet.image, sheet.info:getFrameIndex(objectName), rowSize / 2, rowSize / 2), 
				background = display.newRect(rowSize / 2, rowSize / 2, rowSize, rowSize) 
			},
		}
	}
end

function Widget:selectRow(row)
    -- Задаем новый обработчик касания по карте
    manada:getActiveMap():removeTouchHandler()

    -- Подсветка выбранной строки
    for i = 1, self._tableView:getNumRows() do
        local tableRow = self._tableView:getRowAtIndex(i)
        -- Подсвечиваем выбранную
        if row and i == row.index then
            -- Задаем новый обработчик касания по карте
            manada:getActiveMap():setTouchHandler(row.params.handler.name, { factory = row.params.handler.factory })
            tableRow.params.visual.background:setFillColor(unpack(colors.rowBackground.selected))
        -- Сбрасываем у всех остальных
        else
            tableRow.params.visual.background:setFillColor(unpack(colors.rowBackground.default))
        end;
    end
end

return Widget