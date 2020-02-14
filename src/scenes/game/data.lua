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
        stats = soldierStats,
        physics = soldierPhysics
    },
    ["SoldierTeamBlue"] = 
    {
        stats = soldierStats,
        physics = soldierPhysics
    },
    ["SoldierTeamGreen"] =
    {
        stats = soldierStats,
        physics = soldierPhysics
    }
}

data.weapons = 
{
    ["MachineGun"] = 
    {
        rate = 25,
        bullet = ""
    }
}

data.bullets = 
{
    {

    }
}

return data