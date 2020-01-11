local atmHacks = {}

function StartATMHack(source, data)
    atmHacks[source] = true
    Citizen.CreateThread(function()
        while atmHacks[source] do
            TriggerClientEvent('disc-hacker:distanceCheck', source, data.atmCoords, 2, 'atmHackDisable')
            Citizen.Wait(500)
        end
    end)
    if data.code == 'bruteforce' then
        StartBruteForce(source, Config.ATM.Difficulty, function()
            atmHacks[source] = false
            local player = ESX.GetPlayerFromId(source)
            local money = math.random(Config.ATM.MoneyMax)
            player.addMoney(money)
            TriggerClientEvent('disc-hacker:addLine', source, "Obtained $" .. money)
        end, function()
            local shouldContact = math.random(1000)
            if shouldContact <= Config.ATM.PoliceChance then
                NotifyPoliceRadius(data.atmCoords, 50.0, 10000)
            end
        end, function()
            if not atmHacks[source] then
                TriggerClientEvent('disc-hacker:switchApp', source, 'root', 'ATM connection lost')
                TriggerClientEvent('disc-hacker:failure', source)
            end
            return atmHacks[source]
        end)
    else
        TriggerClientEvent('disc-hacker:addLine', source, data.code .. ' is not a valid atm command')
    end
end

RegisterServerEvent('disc-hacker:atmHackDisable')
AddEventHandler('disc-hacker:atmHackDisable', function()
    atmHacks[source] = false
end)