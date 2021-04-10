local data = {}

local soldierStats = 
{
    health = 100,
    moveSpeed = 250
}

local soldierPhysics = 
{
    bodyType = "dynamic",
    params =
    {
        shape = { -76,-29, -45,-60, 28,-52, 70,-15, 74,26, 17,24, -31,61, -67,23, },
        filter = { categoryBits = 1, maskBits = 7 }
    }
}

local barrierPhysics = 
{
    bodyType = "static",
    params = 
    {
        filter = { categoryBits = 2, maskBits = 5 }
    }
}

local bulletPhysics = 
{
    bodyType = "dynamic",
    params = 
    {
        density = 0.1,
        filter = { categoryBits = 4, maskBits = 3 }
    }
}

data.terrains = 
{
    ["Barrier"] = 
    {
        name = "Barrier",
        physics = barrierPhysics
    }
}

data.npcs = 
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
    },
    ["Zombie"] =
    {
        name = "Zombie",
        stats = soldierStats,
        physics = soldierPhysics,
        allies = { "Zombie" }
    }
}

data.weapons = 
{
    ["MachineGun"] = 
    {
        name = "MachineGun",        -- Имя
        type = "primary",           -- Тип
        weight = 100,               -- Вес
        range = 1750,               -- Дальность
        rate = 100,                 -- Скорость
        spread = 5,                 -- Разброс
        count = 1,                  -- Кол-во пуль
        bullet = "Bullet"           -- Тип пули
    },
    ["SMG"] = 
    {
        name = "SMG",
        type = "primary",
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
        type = "primary",
        weight = 75,
        range = 1000,
        rate = 500,
        spread = 12,
        count = 5,
        bullet = "Bullet"
    },
    ["Hands"] = 
    {
        name = "Hands",
        type = "melee",
        weight = 0,
        range = 0,
        rate = 100,
    }
}

data.bullets = 
{
    ["Bullet"] = 
    {
        name = "Bullet",
        physics = bulletPhysics,
        w = 35,
        h = 6,
        color = { 1, 0.7, 0.15 },
        speed = 5000,
        damage = 15
    }
}

return data