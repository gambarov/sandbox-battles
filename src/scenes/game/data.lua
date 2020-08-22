local data = {}

local soldierStats = 
{
    health = 100
}

local soldierPhysics = 
{
    bodyType = "dynamic",
    params =
    {
        shape = { -76,-29, -45,-60, 28,-52, 70,-15, 74,26, 17,24, -31,61, -67,23, }
    }
}

data.characters = 
{
    ["SoldierTeamPurple"] = 
    {
        name = "SoldierTeamPurple",
        stats = soldierStats,
        physics = soldierPhysics,
        allies = { "SoldierTeamPurple" }
    },
    ["SoldierTeamBlue"] = 
    {
        name = "SoldierTeamBlue",
        stats = soldierStats,
        physics = soldierPhysics,
        allies = { "SoldierTeamBlue" }
    },
    ["SoldierTeamGreen"] =
    {
        name = "SoldierTeamGreen",
        stats = soldierStats,
        physics = soldierPhysics,
        allies = { "SoldierTeamGreen" }
    }
}

data.weapons = 
{
    ["MachineGun"] = 
    {
        name = "MachineGun",
        rate = 100,
        spread = 5,
        count = 1,
        bullet = "Simple"
    },
    ["SMG"] = 
    {
        name = "SMG",
        rate = 175,
        spread = 3,
        count = 1,
        bullet = "Simple"
    },
    ["Shotgun"] = 
    {
        name = "Shotgun",
        rate = 500,
        spread = 10,
        count = 3,
        bullet = "Simple"
    }
}

data.bullets = 
{
    ["Simple"] = 
    {
        name = "Simple",
        w = 40,
        h = 8,
        color = { 0.85, 0.55, 0.35 },
        speed = 500,
        damage = 20
    }
}

return data