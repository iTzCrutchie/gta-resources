RegisterCommand('search', function(source, args, raw)
    print('Searching Event Server')
    TriggerClientEvent('disc-inventoryhud:search', source)
end)

RegisterCommand('steal', function(source, args, raw)
    TriggerClientEvent('disc-inventoryhud:steal', source)
end)

ESX.RegisterServerCallback('disc-inventoryhud:getIdentifier', function(source, cb, serverid)
    cb(ESX.GetPlayerFromId(serverid).identifier)
end)