--
-- created with TexturePacker - https://www.codeandweb.com/texturepacker
--
-- $TexturePacker:SmartUpdate:47db0e07ae99ccdccddec1910f0842b2:acdec6371656f4de9666a2198e7554e9:2f9aa7ed53d9dd429372ba2a00184b66$
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
            -- SquareButtonBG
            x=1,
            y=1,
            width=185,
            height=185,

        },
        {
            -- TableBG
            x=1,
            y=188,
            width=185,
            height=55,

        },
    },

    sheetContentWidth = 187,
    sheetContentHeight = 244
}

SheetInfo.frameIndex =
{

    ["SquareButtonBG"] = 1,
    ["TableBG"] = 2,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
