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
        shape = { -62,-81, 36,-69, 93,-18, 95,36, 22,32, -40,80, -88,29, -100,-43 }
    }
}

data.characters = 
{
    ["SoldierTeamPurple"] = 
    {
        name = "SoldierTeamPurple",
        stats = soldierStats,
        physics = soldierPhysics
    },
    ["SoldierTeamBlue"] = 
    {
        name = "SoldierTeamBlue",
        stats = soldierStats,
        physics = soldierPhysics
    },
    ["SoldierTeamGreen"] =
    {
        name = "SoldierTeamGreen",
        stats = soldierStats,
        physics = soldierPhysics
    }
}

data.weapons = 
{
    ["MachineGun"] = 
    {
        name = "MachineGun",
        rate = 25,
        bullet = ""
    },
    ["SMG"] = 
    {
        name = "SMG",
        rate = 35,
        bullet = ""
    },
    ["Shotgun"] = 
    {
        name = "Shotgun",
        rate = 75,
        bullet = ""
    }
}

data.bullets = 
{
    {

    }
}

return data