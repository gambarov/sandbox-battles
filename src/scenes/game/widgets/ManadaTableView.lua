local class = require("manada.libs.middleclass")

local widget = require("widget")

local Widget = class("GameObjectTableView")

local colors = 
{
    rowColor =      { default = { 0, 0, 0, 0 }, over = { 0, 0, 0, 0 } },
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
        if (event.phase == "release" and self._state ~= "hided") then
            self:highlightRow(event.target.index)    -- Подсветка выбора
            event.target.params.onTouchHandler()     -- Обработчик нажатия данной строки
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

function Widget:insertRow(name, visual, onTouchHandler)
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
            name = name,
            visual = visual,
            onTouchHandler = onTouchHandler   
		}
	}
end

function Widget:highlightRow(index)
    for i = 1, self._tableView:getNumRows() do
        
        local row = self._tableView:getRowAtIndex(i).params
        local visual = row.visual

        if index and (i == index or index == row.name)  then
            visual.background:setFillColor(unpack(colors.rowBackground.selected))
        else
            visual.background:setFillColor(unpack(colors.rowBackground.default))
        end;
    end
end

function Widget:resetHighlight()
    self:highlightRow(false)
end

return Widget