ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

ESX.RegisterUsableItem('hacktool', function(source)
    TriggerClientEvent('disc-hacker:OpenTool', source)
end)

RegisterServerEvent('disc-hacker:sendCommand')
AddEventHandler('disc-hacker:sendCommand', function(data)
    if data.app == 'root' then
        TriggerClientEvent('disc-hacker:addLine', source, data.code .. ' is not a valid root command')
    elseif data.app == 'atm' then
        StartATMHack(source, data)
    end
end)

function StartBruteForce(src, max, endFunction, procFunction, continueFunction)
    Citizen.CreateThread(function()
        TriggerClientEvent('disc-hacker:startHack', src, 'bruteforce')
        local target = math.random(max)
        local atTarget = false
        while not atTarget and continueFunction() do
            procFunction()
            local aim = math.random(max)
            if aim == target then
                atTarget = true
                endFunction()
                TriggerClientEvent('disc-hacker:success', src, aim)
            end
            Citizen.Wait(Config.BruteForce.ThreadSleep)
        end
    end)
end