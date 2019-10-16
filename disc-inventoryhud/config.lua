Config = {}

Config.OpenControl = 289
Config.TrunkOpenControl = 47

Config.Shops = {
    ['My Shop Of Awesome Things'] = {
        coords = {
            vector3(44.38, -1746.76, 29.5),
            vector3(44.38, -1742.76, 29.5),
        },
        items = {
            { name = "bread", price = 100, count = 10 },
            { name = "water", price = 100, count = 10 },
            { name = "disc_ammo_pistol", price = 100, count = 10 },
            { name = "disc_ammo_pistol_large", price = 1000, count = 10 },
            { name = "WEAPON_SNSPISTOL", price = 100, count = 10 },
        },
        markerType = 1,
        markerColour = { r = 255, g = 255, b = 255 },
        msg = 'Open Shop ~INPUT_CONTEXT~',
        enableBlip = true,
        job = 'all'
    }
}

Config.Stash = {
    ['Police'] = {
        coords = vector3(457.76, -981.05, 30.69),
        size = vector3(1.0, 1.0, 1.0),
        job = 'police',
        markerType = 2,
        markerColour = { r = 255, g = 255, b = 255 },
        msg = 'Open Stash ~INPUT_CONTEXT~'
    }
}