local data = {}

local soldierStats = 
{
    health = 100,
    moveSpeed = 200
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
        weight = 100,
        range = 1750,
        rate = 100,
        spread = 5,
        count = 1,
        bullet = "Bullet"
    },
    ["SMG"] = 
    {
        name = "SMG",
        weight = 50,
        range = 2250,
        rate = 175,
        spread = 3,
        count = 1,
        bullet = "Bullet"
    },
    ["Shotgun"] = 
    {
        name = "Shotgun",
        weight = 75,
        range = 1000,
        rate = 500,
        spread = 12,
        count = 4,
        bullet = "Bullet"
    }
}

data.bullets = 
{
    ["Bullet"] = 
    {
        name = "Bullet",
        w = 35,
        h = 6,
        color = { 1, 0.7, 0.15 },
        speed = 5000,
        damage = 15
    }
}

return data