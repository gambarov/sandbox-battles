local Plugin = {}

local max  = math.max
local min  = math.min
local sqrt = math.sqrt

local function calculateDelta( previousTouches, event )

	local id, touch = next( previousTouches )
	if ( event.id == id ) then
		id, touch = next( previousTouches, id )
		assert( id ~= event.id )
	end

	local dx = touch.x - event.x
	local dy = touch.y - event.y
	return dx, dy
end

function Plugin:new(instance, params)

    if not instance then
        error( "ERROR: " .. "Expected display object" )
    end
    
    params = params or {}

    if params.background then
        
        local sheet = manada.isheet:get(params.background.isheetName)
        local bg = display.newImage(params.background.parent, sheet.image, sheet.info:getFrameIndex(params.background.isheetIndexFrame), display.pixelHeight / 2, display.pixelWidth / 2)
        bg.width, bg.height =  display.pixelHeight, display.pixelWidth

        if params.background.fillColor then
            bg:setFillColor(unpack(params.background.fillColor))
        end
        
        bg:addEventListener("touch", function (event)
            if instance["touch"] then
                return instance:touch(event)
            end
        end)
    end
    
    function instance:touch(event)
        
		local result = true
        local phase = event.phase
        local previousTouches = self.previousTouches
        local numTotalTouches = 1

        if previousTouches then
            -- Add in total from "previousTouches", subtracting 1 if event is already in the array
            numTotalTouches = numTotalTouches + self.numPreviousTouches
            if previousTouches[event.id] then
                numTotalTouches = numTotalTouches - 1
            end
        end

        if ( "began" == phase ) then
            -- Set touch focus on first "began" event
            if not self.isFocus then
                display.currentStage:setFocus( self )
                self.isFocus = true
                -- Reset "previousTouches"
                previousTouches = {}
                self.previousTouches = previousTouches
                self.numPreviousTouches = 0

                self.markX = self.x
                self.markY = self.y
                -- self.markX = event.x
                -- self.markY = event.y

            elseif not self.distance then
                local dx, dy
                if previousTouches and ( numTotalTouches ) >= 2 then
                    dx, dy = calculateDelta( previousTouches, event )
                end
                -- Initialize the distance between two touches
                if ( dx and dy ) then
                    local d = sqrt( dx*dx + dy*dy )
                    if ( d > 0 ) then
                        self.distance = d
                        self.xScaleOriginal = self.xScale
                        self.yScaleOriginal = self.yScale
                        --print( "Distance: " .. self.distance )
                    end
                end
            end

            if not previousTouches[event.id] then
                self.numPreviousTouches = self.numPreviousTouches + 1
            end
            previousTouches[event.id] = event

        -- If image is already in touch focus, handle other phases
        elseif self.isFocus then

            -- Handle touch moved phase
            if ( "moved" == phase ) then

                if numTotalTouches == 1 then
                    
                    -- local anchorXOffset = (event.x - self.markX) / display.pixelHeight / max(1, self.xScale)
                    -- local anchorYOffset = (event.y - self.markY) / display.pixelWidth / max(1, self.yScale)

                    -- self.markX = event.x
                    -- self.markY = event.y

                    -- self.anchorX, self.anchorY = self.anchorX - anchorXOffset, self.anchorY - anchorYOffset

                    self.x = event.x - event.xStart + self.markX
                    self.y = event.y - event.yStart + self.markY
                end

                if self.distance then
                    local dx, dy
                    -- Must be at least 2 touches remaining to pinch/zoom
                    if ( previousTouches and numTotalTouches >= 2 ) then
                        dx, dy = calculateDelta( previousTouches, event )
                    end

                    if ( dx and dy ) then
                        local newDistance = sqrt( dx*dx + dy*dy )
                        local scale = newDistance / self.distance
                        --print( "newDistance(" ..newDistance .. ") / distance(" .. self.distance .. ") = scale("..  scale ..")" )
                        if ( scale > 0 ) then
                            self.xScale = self.xScaleOriginal * scale
                            self.yScale = self.yScaleOriginal * scale

                            self.xScale, self.yScale = max(self.xScale, 0.25), max(self.yScale, 0.25)
                            self.xScale, self.yScale = min(self.xScale, 2), min(self.yScale, 2)
                        end
                    end
                end

                if not previousTouches[event.id] then
                    self.numPreviousTouches = self.numPreviousTouches + 1
                end
                previousTouches[event.id] = event

            -- Handle touch ended and/or cancelled phases
            elseif ( "ended" == phase or "cancelled" == phase ) then

                if previousTouches[event.id] then
                    self.numPreviousTouches = self.numPreviousTouches - 1
                    previousTouches[event.id] = nil
                end

                if ( #previousTouches > 0 ) then
                    self.distance = nil
                else
                    -- Since "previousTouches" is empty, no more fingers are touching the screen
                    -- Thus, reset touch focus (remove from image)
                    display.currentStage:setFocus( nil )
                    self.isFocus = false
                    self.distance = nil
                    self.xScaleOriginal = nil
                    self.yScaleOriginal = nil
                    -- Reset array
                    self.previousTouches = nil
                    self.numPreviousTouches = nil

                    self.markX = nil
                    self.markY = nil
                end
            end
        end

        return result
	end

    instance:addEventListener("touch")
    return instance
end

return Plugin
