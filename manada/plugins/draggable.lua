local Plugin = {}

function Plugin:new( instance )

    if not instance then
        error( "ERROR: " .. "Expected display object" )
    end

    function instance:touch( event )

        if event.phase == "began" then

            display.getCurrentStage():setFocus( self._group, event.id )
            self.isFocus = true
            self.markX = self.x
            self.markY = self.y

        elseif self.isFocus then

            if event.phase == "moved" then

                self.x = event.x - event.xStart + self.markX
                self.y = event.y - event.yStart + self.markY

            elseif event.phase == "ended" or event.phase == "cancelled" then

                display.getCurrentStage():setFocus( self._group, nil )
                self.isFocus = false

            end
        end

        return true

    end

    instance:addEventListener( "touch" )
    return instance

end

return Plugin
