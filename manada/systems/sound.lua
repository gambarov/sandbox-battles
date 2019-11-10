local class = require( "manada.libs.middleclass" )

local Sound = class( "Sound" )

-- Доступные расширения файлов
Sound.exts = {}
Sound.exts.wav = "wav"
Sound.exts.mp3 = "mp3"
Sound.exts.ogg = "ogg"
Sound.exts.aac = "aac"
Sound.exts.caf = "caf"
Sound.exts.aif = "aif"

function Sound:initialize( params )

    -- Таблица, содержащая все звуки
    self._sounds = {}

    -- Задаем расширение файлов по-умолчанию
    self:setDefaultExt(Sound.exts.wav)

end

function Sound:get(name, ext)

    ext = ext or self:getDefaultExt()

    local sound = self._sounds[ name ][ ext ]

    if not sound then
        print("WARNING: " .. "can't find sound \"" .. name .. "." .. ext .. "\"")
    end

    return sound

end

function Sound:remove(name, ext)

    -- Удаление звука с нужным расширением
    if ext then

        if self:get(name, ext) then
            
            audio.dispose( self._sounds[ name ][ ext ])
            self._sounds[ name ][ ext ] = nil
            return true

        end

    -- Удаление всех типов звуков с данным именем
    else

        for _, ext in pairs(Sound.exts) do
            if not self:remove(name, ext) then
                return false
            end
        end

        return true

    end

    return false

end

function Sound:add(name, path, baseDir)

    local ext = manada.file:getFileExtension(path)

    -- Если идет перезапись значения, то очищаем из памяти старое
    if self._sounds[ name ][ ext ] then
        self:remove(name, ext)
    end

    local sound = audio.loadSound( path, baseDir or system.ResourceDirectory )
    self._sounds[ name ][ ext ] = sound

end

function Sound:play(name, ext, options)

    options = options or {}
    return audio.play(self:get(name, ext), options)

end

function Sound:setDefaultExt( ext )
    self._defaulfExt = ext
end

function Sound:getDefaultExt()
    return self._defaulfExt
end

return Sound