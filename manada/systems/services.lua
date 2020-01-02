local class = require("manada.libs.middleclass")

local Services = class("Services")

function Services:initialize(params)
    self._services = {}
end

function Services:provide(name, service, params)
    self._services[name] = service:new(params)
end

function Services:get(name)
    assert(self._services, "Can't get \"" .. name .. "\" service because no service has been added yet")
    local service = self._services[name]
    assert(service, "Can't get \"" .. name .. "\" service because don't exist")
    return service
end

return Services