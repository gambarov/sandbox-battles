-- need sliding panel
local widget = require("widget")

local gameObjectFactory = require("src.scenes.game.gameObjects.factories.NPCFactory"):new()
local barrierFactory = require("src.scenes.game.gameObjects.factories.BarrierFactory"):new()

local uiGroup = display.newGroup()

local xBtn = 0.1 * display.pixelHeight
local yBtn = 0.85 * display.pixelWidth
local widthBtn = 0.15 * display.pixelHeight
local heightBtn = 0.1 * display.pixelWidth
local sizeBtn = (widthBtn + heightBtn) / 2
local offsetBtn = 25

local function addButton(displayGroup, text, x, y, handler)
    -- Create the widget
    local button = widget.newButton(
        {
            label = text,
            onEvent = handler,
            emboss = false,
            -- Properties for a rounded rectangle button
            shape = "roundedRect",
            width = sizeBtn,
            height = sizeBtn,
            cornerRadius = 2,
            fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
            strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
            strokeWidth = 4
        }
    )

    button.x, button.y = x, y
    displayGroup:insert(button)
end

addButton(uiGroup, "REMOVE", xBtn, yBtn, function (event)
    if event.phase == "ended" then
        manada:getActiveMap():setTouchHandler("BlockRemoveHandler")
    end
end)

-- Set color variables depending on theme
local tableViewColors = {
	rowColor = { default = { 48/255 }, over = { 72/255 } },
	lineColor = { 36/255 },
	catColor = { default = { 80/255, 80/255, 80/255, 0.9 }, over = { 80/255, 80/255, 80/255, 0.9 } },
	defaultLabelColor = { 1, 1, 1, 0.6 },
	catLabelColor = { 1 }
}

-- Forward reference for the tableView
local tableView

-- Listen for tableView events
local function tableViewListener( event )
	local phase = event.phase
	-- print( "Event.phase is:", event.phase )
end

-- Handle row rendering
local function onRowRender( event )

	local row = event.row
	local groupContentHeight = row.contentHeight
	
	-- local rowTitle = display.newText( row, "Row " .. row.index, 0, 0, nil, 14 )
	local sheet    = manada.isheet:get("gameObjects")
	local rowTitle = display.newImage(row, sheet.image, sheet.info:getFrameIndex(row.params.name), display.pixelHeight * 0.25 / 2, 128)
	rowTitle:scale(0.85, 0.85)

	if ( row.isCategory ) then
		rowTitle:setFillColor( unpack(row.params.catLabelColor) )
		-- rowTitle.text = rowTitle.text.." (category)"
	else
		rowTitle:setFillColor( unpack(row.params.defaultLabelColor) )
	end
end

local function onRowUpdate( event )
	local phase = event.phase
	local row = event.row
	print( row.index, ": is now onscreen" )
end

local function onRowTouch( event )
	local phase = event.phase
	local row = event.target
	
	if (phase == "release") then
		manada:getActiveMap():setTouchHandler(row.params.handler.name, { factory = row.params.handler.factory })
	end
end

tableView = widget.newTableView
{
	top = 0,
	left = display.pixelHeight - (display.pixelHeight * 0.25),
	width = display.pixelHeight * 0.25, 
	height = display.pixelWidth,
	rowTouchDelay = 5,

	hideBackground = false,
	backgroundColor = { 0.22, 0.22, 0.22 },
	listener = tableViewListener,
	onRowRender = onRowRender,
	onRowUpdate = onRowUpdate,
	onRowTouch = onRowTouch,
}
uiGroup:insert( tableView )

tableView:insertRow
{
	isCategory = false,
	rowHeight = 256,
	rowColor = {
		default = tableViewColors.rowColor.default,
		over = tableViewColors.rowColor.over
	},
	lineColor = tableViewColors.lineColor,
	params = { name = "Soldier", handler = { name = "NPCSpawnHandler", factory = gameObjectFactory }, defaultLabelColor=tableViewColors.defaultLabelColor, catLabelColor=tableViewColors.catLabelColor }
}
tableView:insertRow
{
	isCategory = false,
	rowHeight = 256,
	rowColor = {
		default = tableViewColors.rowColor.default,
		over = tableViewColors.rowColor.over
	},
	lineColor = tableViewColors.lineColor,
	params = { name = "BlockBox1", handler = { name = "BlockSpawnHandler", factory = barrierFactory }, defaultLabelColor=tableViewColors.defaultLabelColor, catLabelColor=tableViewColors.catLabelColor }
}

return uiGroup