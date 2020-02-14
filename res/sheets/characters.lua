--
-- created with TexturePacker - https://www.codeandweb.com/texturepacker
--
-- $TexturePacker:SmartUpdate:8a78d9accb47b4dd96676178d95c65b3:7ccebecbe9b4f3921593f2beee9272c7:f94c4674a58e1ee53e1cb2fa4af30ee6$
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
            -- SoldierTeamBlue
            x=1,
            y=1,
            width=150,
            height=121,

        },
        {
            -- SoldierTeamGreen
            x=153,
            y=1,
            width=150,
            height=121,

        },
        {
            -- SoldierTeamPurple
            x=305,
            y=1,
            width=150,
            height=121,

        },
    },

    sheetContentWidth = 456,
    sheetContentHeight = 123
}

SheetInfo.frameIndex =
{

    ["SoldierTeamBlue"] = 1,
    ["SoldierTeamGreen"] = 2,
    ["SoldierTeamPurple"] = 3,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
