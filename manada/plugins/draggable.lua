local Plugin = {}

function Plugin:new( instance )

    if not instance then
        error( "ERROR: " .. "Expected display object" )
    end

    function instance:touch( event )

        if event.phase == "began" then

            display.getCurrentStage():setFocus(instance)
            self.isFocus = true
            self._dragMarkX = self.x
            self._dragMarkY = self.y

        elseif self.isFocus then

            if event.phase == "moved" then

                self.x = event.x - event.xStart + self._dragMarkX
                self.y = event.y - event.yStart + self._dragMarkY

            elseif event.phase == "ended" or event.phase == "cancelled" then

                display.getCurrentStage():setFocus( instance, nil )
                self.isFocus = false
                self._dragMarkX = nil
                self._dragMarkY = nil

            end
        end

        return true
    end

    instance:addEventListener( "touch" )
    return instance

end

return Plugin
