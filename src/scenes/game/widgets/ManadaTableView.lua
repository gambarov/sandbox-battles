local class = require("manada.libs.middleclass")

local widget = require("widget")

local Widget = class("GameObjectTableView")

local colors = {
    rowColor = { default = { 0, 0, 0, 0 }, over = { 0, 0, 0, 0 } },
    rowBackground = { default = { 255/255, 255/255, 255/255, 1 }, selected = { 220/255, 200/255, 110/255, 0.5 } }
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
        backgroundColor = { 0.22, 0.22, 0.22, 0.95 },
        onRowRender = onRowRender,
        onRowTouch = onRowTouch,
    }

    self._state = "shown"

    self._left = params.left
    self._top  = params.top

    self._group = display.newGroup()
    self._group:insert(self._tableView)

    self:show(false)
end

function Widget:show(animated)

    self._state = "shown"
    self._tableView.isVisible = true

    if animated then
        transition.cancel(self._transition)
        self._transition = transition.to(self._tableView, { x = self._left + tableWidth / 2, time = 50 })
    else
        self._tableView.x = self._left + tableWidth / 2
    end
end

function Widget:hide(animated)
    
    self._state = "hided"

    if animated then
        transition.cancel(self._transition)
        self._transition = transition.to(self._tableView, { x = self._left + tableWidth * 2, time = 50, onComplete = function() self._tableView.isVisible = false end })
    else
        self._tableView.isVisible = false
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
    -- Если таблица закрыта, то выбор невозможен
    if self._state == "hided" then
        return
    end

    -- Подсветка выбранной строки
    for i = 1, self._tableView:getNumRows() do
        local visual = self._tableView:getRowAtIndex(i).params.visual
        -- Подсвечиваем выбранную
        if row and i == row.index then
            -- Задаем новый обработчик касания по карте
            visual.background:setFillColor(unpack(colors.rowBackground.selected))
            
            if row.params then
                row.params.onTouchHandler()
            end
        -- Сбрасываем у всех остальных
        else
            visual.background:setFillColor(unpack(colors.rowBackground.default))
        end;
    end
end

return Widget