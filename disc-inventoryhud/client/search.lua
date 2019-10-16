local secondarySearchInventory = {
    type = 'player',
    owner = ''
}

RegisterNetEvent('disc-inventoryhud:search')
AddEventHandler('disc-inventoryhud:search', function()
    print('Searching')
    local player = ESX.GetPlayerData()
    if player.job.name == 'police' then
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer ~= -1 and closestDistance <= 3.0 then
            local searchPlayerPed = GetPlayerPed(closestPlayer)
            if IsEntityPlayingAnim(searchPlayerPed, 'mp_arresting', 'idle', 3) or IsEntityDead(searchPlayerPed) or GetEntityHealth(searchPlayerPed) <= 0 then
                ESX.TriggerServerCallback('disc-inventoryhud:getIdentifier', function(identifier)
                    secondarySearchInventory.owner = identifier
                    openInventory(secondarySearchInventory)
                end, GetPlayerServerId(closestPlayer))
            end
        end
    end
end)

RegisterNetEvent('disc-inventoryhud:steal')
AddEventHandler('disc-inventoryhud:steal', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        local searchPlayerPed = GetPlayerPed(closestPlayer)
        if IsEntityPlayingAnim(searchPlayerPed, 'random@mugging3', 'handsup_standing_base', 3) then
            ESX.TriggerServerCallback('disc-inventoryhud:getIdentifier', function(identifier)
                secondarySearchInventory.owner = identifier
                openInventory(secondarySearchInventory)
            end, GetPlayerServerId(closestPlayer))
        end
    end
end)