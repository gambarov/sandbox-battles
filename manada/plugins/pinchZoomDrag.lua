local Plugin = {}

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

function Plugin:new(instance)

    if not instance then
        error( "ERROR: " .. "Expected display object" )
    end
	
	prevX = instance.x
	prevY = instance.y
	
	isMulti = false

    function instance:touch(event)
        
        print("1")

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

            elseif not self.distance then
                local dx, dy
                if previousTouches and ( numTotalTouches ) >= 2 then
                    dx, dy = calculateDelta( previousTouches, event )
                end
                -- Initialize the distance between two touches
                if ( dx and dy ) then
                    local d = math.sqrt( dx*dx + dy*dy )
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
                        local newDistance = math.sqrt( dx*dx + dy*dy )
                        local scale = newDistance / self.distance
                        --print( "newDistance(" ..newDistance .. ") / distance(" .. self.distance .. ") = scale("..  scale ..")" )
                        if ( scale > 0 ) then
                            self.xScale = self.xScaleOriginal * scale
                            self.yScale = self.yScaleOriginal * scale
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
