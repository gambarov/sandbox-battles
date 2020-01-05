local Plugin = {}

local touches = {}
local lastDistance = false

function Plugin:new( instance )

    if not instance then
        error( "ERROR: " .. "Expected display object" )
    end

    function instance:touch( event )

        local handled = false

        if event.phase == "began" then

            touches[event.id] = event
            display.getCurrentStage():setFocus( instance, event.id )
            
            if manada.utils:count(touches) >= 2 then
                self.isFocus = true
                handled = true
            end

        elseif self.isFocus then

            if event.phase == "moved" then
                -- Обновляем координаты текущего касания
                touches[event.id] = event

                -- Получаем два первых касания
                local t1 = manada.utils:getByIndex(touches, 1)
                local t2 = manada.utils:getByIndex(touches, 2)

                local distance = manada.utils:distanceBetween(t1, t2)

                -- Если уже пошел процесс зума
                if lastDistance then
                    -- Приближаем объект
                    if distance > lastDistance then
                        instance:scale(1.1, 1.1)
                    -- Иначе отдаляем
                    else
                        instance:scale(0.9, 0.9)
                    end

                    return true
                end

                lastDistance = distance


            elseif event.phase == "ended" or event.phase == "cancelled" then

                touches[event.id] = nil
                lastDistance = false

                if manada.utils:count(touches) == 0 then
                    display.getCurrentStage():setFocus(instance, nil)
                    self.isFocus = false
                end

                return false
            end
        end

        return false

    end

    instance:addEventListener( "touch" )
    return instance

end

return Plugin
