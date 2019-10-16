secondInventory = nil

RegisterNUICallback('MoveToEmpty', function(data)
    TriggerServerEvent('disc-inventoryhud:MoveToEmpty', data)
    TriggerEvent('disc-inventoryhud:MoveToEmpty', data)
end)

RegisterNUICallback('EmptySplitStack', function(data)
    TriggerServerEvent('disc-inventoryhud:EmptySplitStack', data)
    TriggerEvent('disc-inventoryhud:EmptySplitStack', data)
end)

RegisterNUICallback('SplitStack', function(data)
    TriggerServerEvent('disc-inventoryhud:SplitStack', data)
    TriggerEvent('disc-inventoryhud:SplitStack', data)
end)

RegisterNUICallback('CombineStack', function(data)
    TriggerServerEvent('disc-inventoryhud:CombineStack', data)
    TriggerEvent('disc-inventoryhud:CombineStack', data)
end)

RegisterNUICallback('SwapItems', function(data)
    TriggerServerEvent('disc-inventoryhud:SwapItems', data)
    TriggerEvent('disc-inventoryhud:SwapItems', data)
end)

RegisterNUICallback('GiveItem', function(data, cb)
    TriggerServerEvent('disc-inventoryhud:notifyImpendingRemoval', data.item, data.number)
    TriggerServerEvent('disc-inventoryhud:GiveItem', data)
    cb('OK')
end)

RegisterNUICallback('GiveCash', function(data, cb)
    TriggerServerEvent('disc-inventoryhud:GiveCash', data)
    cb('OK')
end)

RegisterNUICallback('GetNearPlayers', function(data)

    if data.action == 'give' then
        SendNUIMessage({
            action = "nearPlayersGive",
            players = GetNeareastPlayers(),
            item = data.item
        })
    end

    if data.action == 'pay' then
        SendNUIMessage({
            action = "nearPlayersPay",
            players = GetNeareastPlayers(),
        })
    end
end)

function GetNeareastPlayers()
    local playerPed = PlayerPedId()
    local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 2.0)

    local players_clean = {}
    local found_players = false

    for i = 1, #players, 1 do
        if players[i] ~= PlayerId() then
            found_players = true
            table.insert(players_clean, { name = GetPlayerName(players[i]), id = GetPlayerServerId(players[i]) })
        end
    end
    return players_clean
end

RegisterNetEvent('disc-inventoryhud:refreshInventory')
AddEventHandler('disc-inventoryhud:refreshInventory', function()
    refreshPlayerInventory()
    if secondInventory ~= nil then
        refreshSecondaryInventory()
    end
end)

function refreshPlayerInventory()
    ESX.TriggerServerCallback('disc-inventoryhud:getPlayerInventory', function(data)
        SendNUIMessage(
                { action = "setItems",
                  itemList = data.inventory,
                  invOwner = data.invId,
                  invTier = data.invTier,
                  money = {
                      cash = data.cash,
                      bank = data.bank,
                  }
                }
        )
        TriggerServerEvent('disc-inventoryhud:openInventory', {
            type = 'player',
            owner = ESX.GetPlayerData().identifier
        })
    end, 'player', ESX.GetPlayerData().identifier)
end

function refreshSecondaryInventory()
    ESX.TriggerServerCallback('disc-inventoryhud:getSecondaryInventory', function(data)
        SendNUIMessage(
                { action = "setSecondInventoryItems",
                  itemList = data.inventory,
                  invOwner = data.invId,
                  invTier = data.invTier,
                }
        )
        TriggerServerEvent('disc-inventoryhud:openInventory', secondInventory)
    end, secondInventory.type, secondInventory.owner)
end

function closeInventory()
    isInInventory = false
    SendNUIMessage({ action = "hide" })
    SetNuiFocus(false, false)
    TriggerServerEvent('disc-inventoryhud:closeInventory', {
        type = 'player',
        owner = ESX.GetPlayerData().identifier
    })
    if secondInventory ~= nil then
        TriggerServerEvent('disc-inventoryhud:closeInventory', secondInventory)
    end
end

RegisterNetEvent('disc-inventoryhud:openInventory')
AddEventHandler('disc-inventoryhud:openInventory', function(sI)
    openInventory(sI)
end)

function openInventory(_secondInventory)
    isInInventory = true
    refreshPlayerInventory()
    SendNUIMessage({
        action = "display",
        type = "normal"
    })
    if _secondInventory ~= nil then
        secondInventory = _secondInventory
        refreshSecondaryInventory()
        SendNUIMessage({
            action = "display",
            type = 'secondary'
        })
    end
    SetNuiFocus(true, true)
end

RegisterNetEvent("disc-inventoryhud:MoveToEmpty")
AddEventHandler("disc-inventoryhud:MoveToEmpty", function(data)
    playPickupOrDropAnimation(data)
end)

RegisterNetEvent("disc-inventoryhud:EmptySplitStack")
AddEventHandler("disc-inventoryhud:EmptySplitStack", function(data)
    playPickupOrDropAnimation(data)
end)

RegisterNetEvent("disc-inventoryhud:SplitStack")
AddEventHandler("disc-inventoryhud:SplitStack", function(data)
    playPickupOrDropAnimation(data)
end)

RegisterNetEvent("disc-inventoryhud:CombineStack")
AddEventHandler("disc-inventoryhud:CombineStack", function(data)
    playPickupOrDropAnimation(data)
end)

RegisterNetEvent("disc-inventoryhud:SwapItems")
AddEventHandler("disc-inventoryhud:SwapItems", function(data)
    playPickupOrDropAnimation(data)
end)

function playPickupOrDropAnimation(data)
    if data.originTier.name == 'drop' or data.destinationTier.name == 'drop' then
        local playerPed = GetPlayerPed(-1)
        if not IsEntityPlayingAnim(playerPed, 'random@domestic', 'pickup_low', 3) then
            ESX.Streaming.RequestAnimDict('random@domestic', function()
                TaskPlayAnim(playerPed, 'random@domestic', 'pickup_low', 8.0, -8, -1, 48, 0, 0, 0, 0)
            end)
        end
    end
end