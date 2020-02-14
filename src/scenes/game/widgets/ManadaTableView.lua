local class = require("manada.libs.middleclass")

local widget = require("widget")

local Widget = class("GameObjectTableView")

local colors = {
    rowColor = { default = { 0, 0, 0, 0 }, over = { 0, 0, 0, 0 } },
    rowBackground = { default = { 100/255, 100/255, 135/255, 1 }, selected = { 220/255, 200/255, 110/255, 0.5 } }
}

local tableWidth = display.pixelHeight * 0.095

function Widget:initialize(params)

    local function onRowRender( event )

        local row = event.row
        local bg = row.params.visual.background
        local icon = row.params.visual.icon

        local function updateVisual(object)
            row:insert(object)
            local percent = (tableWidth * 100) / object.width - 100
            local height = object.height / 100 * percent + object.height
            object.width, object.height = tableWidth, height
            object.x, object.y = tableWidth / 2, tableWidth / 2
        end

        updateVisual(bg)
        updateVisual(icon)

        bg.xScale, bg.yScale = 0.75, 0.75
        icon.xScale, icon.yScale = 0.55, 0.55
    end

    local function onRowTouch( event )
        -- Выбор строки, по которой нажал юзер
        if (event.phase == "release") then
            self:selectRow(event.target)
        end
    end

    self._tableView = widget.newTableView
    {
        top = params.top,
        left = params.left,
        width = tableWidth, 
        height = display.pixelWidth,
        rowTouchDelay = 5,
        noLines = true,
        hideBackground = false,
        backgroundColor = { 45 / 255, 45 / 255, 45 / 255, 1 },
        onRowRender = onRowRender,
        onRowTouch = onRowTouch,
    }

    self._state = "showed"

    self._left = params.left
    self._top  = params.top

    self._group = params.displayGroup
    self._group:insert(self._tableView)
    self:show(false)
end

function Widget:show(animated)
    self._state = "showed"

    if animated then
        transition.to(self._tableView, { x = self._left + tableWidth / 2, time = 300 })
    else
        self._tableView.x = self._left + tableWidth / 2
    end
end

function Widget:hide(animated)
    self._state = "hided"

    if animated then
        transition.to(self._tableView, { x = self._left + tableWidth * 2, time = 300 })
    else
        self._tableView.x = self._left + tableWidth * 2
    end
end

function Widget:insertRow(visual, onTouchHandler)
	self._tableView:insertRow
	{
		isCategory = false,
		rowHeight = tableWidth,
		rowColor = {
			default = colors.rowColor.default,
			over = colors.rowColor.over
		},
		params = 
		{ 
            visual = visual,
            onTouchHandler = onTouchHandler   
		}
	}
end

function Widget:selectRow(row)

    if self._state == "hided" then
        return
    end

    -- Подсветка выбранной строки
    for i = 1, self._tableView:getNumRows() do
        local tableRow = self._tableView:getRowAtIndex(i)
        -- Подсвечиваем выбранную
        if row and i == row.index then
            -- Задаем новый обработчик касания по карте
            tableRow.params.visual.background:setFillColor(unpack(colors.rowBackground.selected))
            return row.params.onTouchHandler()
        -- Сбрасываем у всех остальных
        else
            tableRow.params.visual.background:setFillColor(unpack(colors.rowBackground.default))
        end;
    end
end

return Widget