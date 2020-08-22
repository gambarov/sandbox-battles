--
-- created with TexturePacker - https://www.codeandweb.com/texturepacker
--
-- $TexturePacker:SmartUpdate:6fd19aa79f5833c1a6cf0a10153a6133:0774dc36d99adb115add63dd818da3f9:1917c218a53722d4cc9389d6c293b8ad$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- MachineGun
            x=1,
            y=1,
            width=158,
            height=41,

        },
        {
            -- Shotgun
            x=268,
            y=1,
            width=138,
            height=32,

        },
        {
            -- SMG
            x=161,
            y=1,
            width=105,
            height=37,

        },
    },

    sheetContentWidth = 407,
    sheetContentHeight = 43
}

SheetInfo.frameIndex =
{

    ["MachineGun"] = 1,
    ["Shotgun"] = 2,
    ["SMG"] = 3,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
