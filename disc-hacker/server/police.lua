function NotifyPoliceRadius(coords, radius, time)
    local players = ESX.GetPlayers()
    for k, v in ipairs(players)do
        local player = ESX.GetPlayerFromId(v)
        if player.job.name == 'police' then
            TriggerClientEvent('disc-hacker:notifyRadius', player.source, coords, radius, time)
        end
    end
end