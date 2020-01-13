local class = require("manada.libs.middleclass")

local Data = class("Data")

local json = require("json")

function Data:initialize(params)
    -- Путь до файла с данными    
    self._path = "manada.data"
    -- Таблица данных
    self._contents = {}

    Runtime:addEventListener("system", self)
end

function Data:load()
    -- Сброс таблицы с данными
    self._contents = {}

    local data = manada.file:read(self._path, system.DocumentsDirectory)
    
    if data then
        -- Преобразовываем в таблицу
        data = json.decode(data)

        if data and type(data) == "table" then
            for k, v in pairs(data) do
                self._contents[k] = v
            end
    
            return true
        end
    end

    return false
end

function Data:save()
    -- Кодируем данные в json
    local data = json.encode(self._contents)
    -- Записываем в файл
    return manada.file:write(data, self._path, system.DocumentsDirectory)
end

function Data:set(name, value)
    -- Присваиваем значение
    self._contents[name] = value
    -- Сохраняем данные
    self:save()
end

function Data:get(name)
    -- Возвращение всей таблицы
    if not name then
        return self._contents
    end

    -- Конкретные данные
    return self._contents[name]
end

function Data:system( event )
    -- Если произошло закрытие приложения, сохраняем данные
	if event.type == "applicationExit" or event.type == "applicationSuspend" then
		self:save()
	end
end

return Data