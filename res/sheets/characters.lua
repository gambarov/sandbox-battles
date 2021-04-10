--
-- created with TexturePacker - https://www.codeandweb.com/texturepacker
--
-- $TexturePacker:SmartUpdate:478c2ed827383143611bcc1063d7f75a:2199a16e3dc6b97636efcb0c6b9f79e0:f94c4674a58e1ee53e1cb2fa4af30ee6$
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
        {
            -- Zombie
            x=457,
            y=1,
            width=118,
            height=115,

        },
    },

    sheetContentWidth = 576,
    sheetContentHeight = 123
}

SheetInfo.frameIndex =
{

    ["SoldierTeamBlue"] = 1,
    ["SoldierTeamGreen"] = 2,
    ["SoldierTeamPurple"] = 3,
    ["Zombie"] = 4,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
