local class = require( "manada.libs.middleclass" )

local File = class ( "File" )

local io = require("io")

function File:initialize( params )
end

function File:read(filename, baseDir)
    -- Путь до файла
    local path = system.pathForFile(filename, baseDir or system.ResourceDirectory)
    -- Открываем файл для чтения
    local file, message = io.open(path, "r")

    if not file then
        -- Ошибка открытия файла
        print("ERROR: " .. message)
        return false
    else
        -- Считываем все содержимое
        local contents = file:read("*a")
        -- Закрываем дескриптор файла
        io.close(file)

        return contents
    end
end

function File:write(data, filename, baseDir)
    -- Путь до файла
    local path = system.pathForFile(filename, baseDir or system.ResourceDirectory)
    -- Открываем файл для записи
    local file, message = io.open(path, "w")

    if not file then
        print("ERROR: " .. message)
        return false
    else
        -- Записываем данные в файл
        file:write(data)    
        -- Закрываем дескриптор файла
        io.close(file)      
        return true
    end
end

function File:getExtensionFromPath(path)

    local temp = manada.utils:splite(path, ".")
    local ext = temp[#temp]

    return ext

end

return File