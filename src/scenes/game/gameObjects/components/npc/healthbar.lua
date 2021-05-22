local class = require("manada.libs.middleclass")

local Component = class("HealthbarComponent")

function Component:initialize(gameObject, params)

    -- Значения по-умолчанию
	params = params or {}

	local x, y = gameObject:getX(), gameObject:getY() - gameObject:getHeight()
	local w, h = gameObject:getWidth(), 18
	local foreground = params.foregroundColor or { 0.28, 0.73, 0.19, 0.75 }
	local background = params.backgroundColor or { 0.1, 0.1, 0.08, 0.75 }

    -- Отдельная группа
    local group = display.newGroup()
    group.anchorChildren = true
    gameObject:getParentGroup():insert(group)

    local stats = gameObject:getComponent("stats")

	group.outline = display.newRect(group, x, y, w + 2.5, h + 2.5)
	group.outline.alpha = 0.6
	group.outline:setFillColor(0, 0, 0)
	group.backgroundBar = display.newRect(group, x, y, w, h)
	group.foregroundBar = display.newRect(group, x, y, w, h)
	group.healthText = display.newText(group,  stats:get("health") .. "/" .. stats:get("health", "original"), x, y, native.systemFontBold, 12)

    local align = params.align or "left"

	if align == "left" then
		group.foregroundBar.anchorX = 0
		group.foregroundBar:translate( -w * 0.5, 0 )
	elseif align == "right" then
		group.foregroundBar.anchorX = 1
		group.foregroundBar:translate( w * 0.5, 0 )
	elseif align == "center" then
		-- Do nothing
	end

    -- Задаем цвета
	group.backgroundBar:setFillColor(unpack(background))
	group.foregroundBar:setFillColor(unpack(foreground))
    -- Объект должен рисоваться поверх всех других (нпс, стены и т.д.)
    group:toFront()
    -- Задаем событие
    gameObject:addEventListener("onDamage", self)
    
    self.group = group
    self.gameObject = gameObject
    self.stats = stats

    self:onDamage({ value = 0 })
    self:update()
end

function Component:onDamage(event)
    local damagePercent = manada.math:calculatePercentage(event.value, self.stats:get("health", "original")) / 100

    self.group.healthText.text = self.stats:get("health", "current") .. "/" .. self.stats:get("health", "original")

    self.percent = (self.percent or 1) - (damagePercent)
    self.percent = math.min( 1, math.max( 0, self.percent ) )
    transition.to(self.group.foregroundBar, { xScale = math.max( 0.001, self.percent ), time = event.speed or 250, transition = easing.outQuad } )
end

function Component:update()
    self.group.x, self.group.y = self.gameObject:getX(), self.gameObject:getY() - (self.gameObject:getHeight() / 1.5)
end

function Component:destroy()
    -- Отписываем от события
    self.gameObject:removeEventListener("onDamage", self)
    self.gameObject = nil
    self.stats = nil
    -- Очищаем визуал и группу
    self.group:removeSelf()
    self.group = nil
end

return Component