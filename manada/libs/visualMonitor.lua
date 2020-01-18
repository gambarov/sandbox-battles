local M = {}
local int, min, fps = math.floor, math.min, display.fps

M.fontSize = 32
M.updateFreq = int( fps / 10 ) -- Ten updates per second
M.updateCount = 0
local prevTime = 0

local minFPS, maxFPS = 60, 0

-- Deep counting number of children in display groups
local function deepNumChildren( group )
	local function countChildren( group )
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

local function addDisplay()
	local group = display.newGroup()

	local background = display.newRect( display.contentCenterX, display.screenOriginY, display.actualContentWidth, M.fontSize*1.75 )
	background.anchorY = 0
	background:setFillColor( 0 )
	background.alpha = 0.65

	local text = display.newText( "", 0, 0, native.systemFont, M.fontSize )
	text:setFillColor( 1 )
	text.x, text.y = display.contentCenterX, display.screenOriginY+(M.fontSize) - (M.fontSize * 0.15)

	group:insert( background )
	group:insert( text )
	group.text = text
	return group
end

local function update( event )
	local curTime = system.getTimer()
	if M.updateCount > M.updateFreq then
		M.updateCount = 0

		local currentFPS = min( display.fps, int( 1000 / ( curTime - prevTime ) ) )
		minFPS = min(currentFPS, minFPS)
		maxFPS = math.max(currentFPS, maxFPS)

		M.group.text.text = "Delta Time: " .. tostring(manada.math:round(manada.time:delta(), 2)) .. " " .. 
	"FPS: ".. tostring( currentFPS .. " (" .. minFPS .. "-" .. maxFPS .. ")" ) .. " " ..
    " Texture Memory: ".. tostring( int( system.getInfo( "textureMemoryUsed" ) * 0.001 ) ) .. "kb " ..
    " System Memory: ".. tostring( int( collectgarbage( "count" ) ) ) .. "kb " ..
    " Stage Objects: " .. tostring( int( deepNumChildren( display.getCurrentStage() ) ) )
	end
	M.group:toFront()
	M.updateCount = M.updateCount + 1
	prevTime = curTime
end

function M:new()
	self.group = addDisplay()
	self.group.isMonitor = true
	Runtime:addEventListener( "enterFrame", update )
	return self.group
end

return M
