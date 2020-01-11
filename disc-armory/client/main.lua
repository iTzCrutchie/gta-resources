ESX = nil
ESXLoaded = false

local currentArmory = nil

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(0)
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
    ESXLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()
    while not ESXLoaded do
        Citizen.Wait(10)
    end
    for k, v in pairs(Config.Armories) do
        local marker = {
            name = v.name,
            type = 29,
            coords = v.coords,
            colour = { r = 55, b = 255, g = 55 },
            size = vector3(1.5, 1.5, 1.0),
            msg = _U('key'),
            action = openArmoryMenu,
            armory = v,
            shouldDraw = function()
                return ESX.PlayerData.job.name == v.job
            end
        }
        TriggerEvent('disc-base:registerMarker', marker)
    end
end)

function openArmoryMenu(marker)
    local menu = {
        name = 'armory',
        title = _U('armory'),
        options = {
            { label = _U('take'), action = showStoredWeapons },
            { label = _U('store'), action = showStoringMenu },
            { label = _U('buy'), action = showBuyMenu },
        }
    }
    currentArmory = marker.armory
    TriggerEvent('disc-base:openMenu', menu)
end

function showStoredWeapons()
    ESX.TriggerServerCallback('disc-armory:getStoredWeapons',
            function(weapons)
                local w = {}

                for k, v in pairs(weapons) do
                    table.insert(w, { label = ESX.GetWeaponLabel(v.weapon) .. (' <span style="color:green;">x%s</span>'):format(v.count), action = function()
                        takeOutWeapon(v.weapon)
                    end })
                end

                local menu = {
                    name = "take_weapons",
                    title = _U('takewea'),
                    options = w
                }

                TriggerEvent('disc-base:openMenu', menu)

            end,
            currentArmory.job)

end

function doesPedHaveWeapon(ped, weapon)
    for i = 1, #Config.Weapons, 1 do

        if Config.Weapons[i].name == weapon then
            local weaponHash = GetHashKey(Config.Weapons[i].name)

            if HasPedGotWeapon(ped, weaponHash, false) then
                return true
            end
        end
    end
    return false
end

function takeOutWeapon(weapon)
    local playerPed = GetPlayerPed(-1)

    if doesPedHaveWeapon(playerPed, weapon) then
        exports['mythic_notify']:SendAlert('success', _U('already') .. ESX.GetWeaponLabel(weapon))
    else
        ESX.TriggerServerCallback('disc-armory:modifyWeaponCount',
                function(result)
                    if result then
                        exports['mythic_notify']:SendAlert('success', _U('took') .. ESX.GetWeaponLabel(weapon))
                        TriggerEvent('esx:addWeapon', weapon, 200)
                        ESX.UI.Menu.Close('default', 'disc-base', 'take_weapons')
                    else
                        exports['mythic_notify']:SendAlert('error', _U('unabletake') .. ESX.GetWeaponLabel(weapon))
                    end
                end, currentArmory.job, weapon, -1)
    end
end

function putWeapon(weapon)
    ESX.TriggerServerCallback('disc-armory:modifyWeaponCount',
            function(result)
                if result then
                    exports['mythic_notify']:SendAlert('success', _U('stored') .. ESX.GetWeaponLabel(weapon))
                    TriggerEvent('esx:removeWeapon', weapon)
                    ESX.UI.Menu.Close('default', 'disc-base', 'store_weapons')
                else
                    exports['mythic_notify']:SendAlert('error', _U('failedstore') .. ESX.GetWeaponLabel(weapon))
                end
            end, currentArmory.job, weapon, 1)
end

function buyWeapon(weapon, price)
    local playerPed = GetPlayerPed(-1)
    if doesPedHaveWeapon(playerPed, weapon) then
        exports['mythic_notify']:SendAlert('success', _U('already') .. ESX.GetWeaponLabel(weapon))
    else
        ESX.TriggerServerCallback('disc-base:buy',
                function(bought)
                    if bought == 1 then
                        TriggerEvent('esx:addWeapon', weapon, 200)
                        exports['mythic_notify']:SendAlert('success', _U('bought') .. ESX.GetWeaponLabel(weapon))
                        ESX.UI.Menu.Close('default', 'disc-base', 'buy_weapons')
                    elseif bought == 0 then
                        exports['mythic_notify']:SendAlert('error', _U('need') .. price .. ' to buy a ' .. ESX.GetWeaponLabel(weapon))
                    else
                        exports['mythic_notify']:SendAlert('error', _U('unablebuyweapon') .. ESX.GetWeaponLabel(weapon))
                    end
                end, price)
    end
end

function showBuyMenu()
    local weapons = {}

    for k, v in pairs(currentArmory.weapons) do
        table.insert(weapons, { label = ESX.GetWeaponLabel(v.name) .. (' <span style="color:green;">$%s</span>'):format(v.price), action = function()
            buyWeapon(v.name, v.price)
        end })
    end

    local menu = {
        name = 'buy_weapons',
        title = _U('buyweapons'),
        options = weapons
    }

    TriggerEvent('disc-base:openMenu', menu)
end

function showStoringMenu()
    local weapons = {}

    for i = 1, #Config.Weapons, 1 do

        local weapon = Config.Weapons[i].name

        local playerPed = GetPlayerPed(-1)
        local weaponHash = GetHashKey(weapon)

        if HasPedGotWeapon(playerPed, weaponHash, false) then
            table.insert(weapons, { label = ESX.GetWeaponLabel(weapon), action = function()
                putWeapon(weapon)
            end })
        end
    end
    local menu = {
        name = "store_weapons",
        title = _U('storeweapon'),
        options = weapons
    }
    TriggerEvent('disc-base:openMenu', menu)
end
