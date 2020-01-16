--
-- created with TexturePacker - https://www.codeandweb.com/texturepacker
--
-- $TexturePacker:SmartUpdate:723fc37e83b27456478df5364245f904:abe26c8bde2469934900b025ed64be97:2c2592776de1da59d67367b56b39db2d$
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
            -- BlockBox1
            x=1,
            y=1,
            width=256,
            height=256,

        },
        {
            -- GroundTile1A
            x=1,
            y=259,
            width=256,
            height=256,

        },
        {
            -- GroundTile1C
            x=1,
            y=517,
            width=256,
            height=256,

        },
        {
            -- GroundTile1D
            x=1,
            y=775,
            width=256,
            height=256,

        },
        {
            -- GroundTile2A
            x=1,
            y=1033,
            width=256,
            height=256,

        },
        {
            -- GroundTile2C
            x=1,
            y=1291,
            width=256,
            height=256,

        },
        {
            -- Soldier
            x=1,
            y=1549,
            width=200,
            height=162,

        },
    },

    sheetContentWidth = 258,
    sheetContentHeight = 1712
}

SheetInfo.frameIndex =
{

    ["BlockBox1"] = 1,
    ["GroundTile1A"] = 2,
    ["GroundTile1C"] = 3,
    ["GroundTile1D"] = 4,
    ["GroundTile2A"] = 5,
    ["GroundTile2C"] = 6,
    ["Soldier"] = 7,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
