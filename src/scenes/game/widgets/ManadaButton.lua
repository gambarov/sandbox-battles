local class = require("manada.libs.middleclass")

local widget = require("widget")

local Button = class("Button")

function Button:initialize(params)
    -- Create the widget
    local button = widget.newButton(
        {
            label = params.text,
            onEvent = params.handler,
            emboss = false,
            -- Properties for a rounded rectangle button
            shape  = "roundedRect",
            width  = params.width,
            height = params.height,
            cornerRadius = 2,
            fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
            strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
            strokeWidth = 4
        }
    )

    button.x, button.y = params.x, params.y
    params.displayGroup:insert(button)

    return button
end

return Button