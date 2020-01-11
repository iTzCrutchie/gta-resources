ESX.RegisterServerCallback('disc-mdt:setBolo', function(source, cb, data)
    local player = ESX.GetPlayerFromId(source)
    MySQL.Async.execute('UPDATE owned_vehicles SET bolo = @bolo , bolo_reason = @reason, bolo_officer=@officer WHERE plate = @plate', {
        ['@plate'] = data.plate,
        ['@bolo'] = data.bolo,
        ['@reason'] = data.reason,
        ['@officer'] = player.identifier
    }, function()
        cb(true)
        local msg = "BOLO for " .. data.plate
        if data.bolo then
            msg = msg .. ' Issued'
        else
            msg = msg .. ' Removed'
        end
        TriggerEvent('disc-mdt:addNotificationToJob', 'police', {
            message = msg
        })
    end)
end)