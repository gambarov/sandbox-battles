--
-- created with TexturePacker - https://www.codeandweb.com/texturepacker
--
-- $TexturePacker:SmartUpdate:30c6b19729309357edf9724b81ca3db7:30339df94299260e8db28a3391c99308:2c2592776de1da59d67367b56b39db2d$
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
            x=259,
            y=1,
            width=256,
            height=256,

        },
        {
            -- GroundTile2A
            x=517,
            y=1,
            width=256,
            height=256,

        },
    },

    sheetContentWidth = 774,
    sheetContentHeight = 258
}

SheetInfo.frameIndex =
{

    ["BlockBox1"] = 1,
    ["GroundTile1A"] = 2,
    ["GroundTile2A"] = 3,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
