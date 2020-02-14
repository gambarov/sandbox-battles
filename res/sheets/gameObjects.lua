--
-- created with TexturePacker - https://www.codeandweb.com/texturepacker
--
-- $TexturePacker:SmartUpdate:5637927fd5addabc7033a93ca5b09c07:38be792be0073e300a76c55f290dcbb8:2c2592776de1da59d67367b56b39db2d$
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
            -- AK47
            x=503,
            y=423,
            width=214,
            height=40,

        },
        {
            -- BlockBox1
            x=1,
            y=503,
            width=256,
            height=256,

        },
        {
            -- GroundTile1A
            x=259,
            y=503,
            width=256,
            height=256,

        },
        {
            -- GroundTile1C
            x=503,
            y=1,
            width=256,
            height=256,

        },
        {
            -- GroundTile1D
            x=517,
            y=465,
            width=256,
            height=256,

        },
        {
            -- GroundTile2A
            x=517,
            y=723,
            width=256,
            height=256,

        },
        {
            -- GroundTile2C
            x=1,
            y=761,
            width=256,
            height=256,

        },
        {
            -- Soldier
            x=503,
            y=259,
            width=200,
            height=162,

        },
        {
            -- Terrain1
            x=1,
            y=1,
            width=500,
            height=500,

        },
    },

    sheetContentWidth = 774,
    sheetContentHeight = 1018
}

SheetInfo.frameIndex =
{

    ["AK47"] = 1,
    ["BlockBox1"] = 2,
    ["GroundTile1A"] = 3,
    ["GroundTile1C"] = 4,
    ["GroundTile1D"] = 5,
    ["GroundTile2A"] = 6,
    ["GroundTile2C"] = 7,
    ["Soldier"] = 8,
    ["Terrain1"] = 9,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
