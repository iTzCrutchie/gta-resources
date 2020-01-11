function sendNotification(source, data)
    TriggerClientEvent('disc-mdt:addNotification', source, data)
end

RegisterServerEvent('disc-mdt:addNotification')
AddEventHandler('disc-mdt:addNotification', function(source, data)
    sendNotification(source, data)
end)

RegisterServerEvent('disc-mdt:addNotificationToJob')
AddEventHandler('disc-mdt:addNotificationToJob', function(job, data)
    local players = ESX.GetPlayers()
    for k, v in ipairs(players) do
        local player = ESX.GetPlayerFromId(v)
        if player.job.name == job then
            sendNotification(player.source, data)
        end
    end
end)