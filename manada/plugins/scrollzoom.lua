local Plugin = {}

local function calculateDelta( instance, previousTouches, event )
	local id,touch = next( previousTouches )
	if event.id == id then
		id,touch = next( previousTouches, id )
		assert( id ~= event.id )
	end

	local dx = touch.x - event.x
	local dy = touch.y - event.y

	midX=math.abs((touch.x + event.x)/2)
	midY=math.abs((touch.y + event.y)/2)
	
	offX=instance.x-midX
	offY=instance.y-midY
	
	return dx, dy,midX,midY,offX,offY
end

local function submitTouch(x,y)
	--use this for a single touch event
end

local isMulti
local prevX 
local prevY
local startX
local startY

function Plugin:new(instance)

    if not instance then
        error( "ERROR: " .. "Expected display object" )
    end
	
	prevX = instance.x
	prevY = instance.y
	
	isMulti = false

    function instance:touch(event)
        
		local scale
		local result = true
        local phase = event.phase
        local previousTouches = self.previousTouches
        local numTotalTouches = 1
        
        if (previousTouches) then
            -- add in total from previousTouches, subtract one if event is already in the array
            numTotalTouches = numTotalTouches + self.numPreviousTouches
            if previousTouches[event.id] then
                numTotalTouches = numTotalTouches - 1
            end
        end

        if "began" == phase then
            -- Very first "began" event
            instance.xScaleOriginal=instance.xScale
            if ( not self.isFocus ) then
                -- Subsequent touch events will target button even if they are outside the contentBounds of button
                display.getCurrentStage():setFocus( self )
                self.isFocus = true
                previousTouches = {}
                self.previousTouches = previousTouches
                self.numPreviousTouches = 0
                ----ADDED BY CON TO ORIGINAL PINCHZOOM CODE
                startX=event.x
                startY=event.y
                --------------------------------
                
            elseif ( not self.distance ) then
                local dx,dy
                isMulti=true
                if previousTouches and ( numTotalTouches ) >= 2 then
                    
                    dx,dy,midX,midY,offX,offY = calculateDelta( instance, previousTouches, event )
                end
                -- initialize to distance between two touches
                if ( dx and dy ) then
                    local d = math.sqrt( dx*dx + dy*dy )
                    if ( d > 0 ) then
                        
                        instance.distance = d
                        offCX=(instance.width*instance.xScale/2)-instance.x
                        offCY=(instance.height*instance.yScale/2)-instance.y
                        local newAnchorX=(midX+offCX)/(instance.width*instance.xScale)
                        local newAnchorY=(midY+offCY)/(instance.height*instance.yScale)
                        
                        instance.anchorX=newAnchorX
                        instance.anchorY=newAnchorY							
                        instance.x=instance.x-offX
                        instance.y=instance.y-offY

                    end
                end
            end
            
            if not previousTouches[event.id] then
                self.numPreviousTouches = self.numPreviousTouches + 1
            end
            previousTouches[event.id] = event

        
        
        elseif self.isFocus then
            if "moved" == phase then
                if ( instance.distance ) then
                    local dx,dy
                    if previousTouches and ( numTotalTouches ) >= 2 then
                        dx,dy = calculateDelta( instance, previousTouches, event )
                    end
        
                    if ( dx and dy ) then
                        local newDistance = math.sqrt( dx*dx + dy*dy )
                        modScale = newDistance / instance.distance
                        if ( modScale > 0 ) then
                            ----MODIFIED BY CON
                            local newScale=instance.xScaleOriginal * modScale
                            -- uncomment below to set max and min scales
                            maxScale,minScale=2,0.2
                            if (newScale>maxScale) then 
                                newScale=maxScale 
                            end
                            if (newScale<minScale) then 
                                newScale=minScale 
                            end

                            instance.xScale = newScale
                            instance.yScale = newScale
                            -----------------------------
                        end
                    end
                ----ADDED BY CON TO ORIGINAL PINCHZOOM CODE

                else
                        local deltaX = prevX+event.x - startX
                        local deltaY = prevY+event.y - startY
                        instance.x = deltaX
                        instance.y = deltaY	
                        --limits on image movement													
                        local limit=300
                        local bounds = instance.contentBounds 
                        -- FIXME:
                        -- if (bounds.xMin>512+limit) then instance.x=instance.x-100 end
                        -- if (bounds.yMin>376+limit) then instance.y=instance.y-100 end							
                        -- if (bounds.xMax<512-limit) then instance.x=instance.x+100 end
                        -- if (bounds.yMax<376-limit) then instance.y=instance.y+100 end
                ---------------------------------
                end

                if not previousTouches[event.id] then
                    self.numPreviousTouches = self.numPreviousTouches + 1
                end
                previousTouches[event.id] = event

            elseif "ended" == phase or "cancelled" == phase then									
                
                if previousTouches[event.id] then
                    self.numPreviousTouches = self.numPreviousTouches - 1
                    previousTouches[event.id] = nil
                end
                
                -- FIXME:
                if (instance.anchorX~=0.5) then
                    axOff=instance.anchorX-0.5
                    ayOff=instance.anchorY-0.5
                    instance.anchorX=0.5
                    instance.anchorY=0.5

                    instance.x=instance.x-(axOff*(instance.width*instance.xScale))
                    instance.y=instance.y-(ayOff*(instance.height*instance.yScale))

                end
                
                if ( #previousTouches > 0 ) then
                    -- must be at least 2 touches remaining to pinch/zoom
                    self.distance = nil

                else
                    -- previousTouches is empty so no more fingers are touching the screen
                    -- Allow touch events to be sent normally to the objects they "hit"
                    display.getCurrentStage():setFocus( nil )
                    self.isFocus = nil
                    self.distance = nil
                    -- reset array
                    self.previousTouches = nil
                    self.numPreviousTouches = nil
                    
                    ----ADDED BY CON TO ORIGINAL PINCHZOOM CODE
                    -- Detecting a touch event or move event that's less than 12 pixels as a selection within the image
                    if (math.abs(startX-event.x)<12) and (math.abs(startY-event.y)<12) and (not isMulti) then 
                        submitTouch(event.x,event.y) 
                    end
                    
                    prevX = instance.x
                    prevY = instance.y
                end
            end
        end

        return result
	end

    instance:addEventListener("touch")
    return instance
end

return Plugin
