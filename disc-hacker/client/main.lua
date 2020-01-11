RegisterNetEvent('disc-hacker:success')
AddEventHandler('disc-hacker:success', function(code)
    SendNUIMessage({
        type = "SUCCESS",
        data = {
            code = code
        }
    })
end)

RegisterNetEvent('disc-hacker:failure')
AddEventHandler('disc-hacker:failure', function()
    SendNUIMessage({
        type = "FAILURE",
    })
end)

RegisterNetEvent('disc-hacker:notACmd')
AddEventHandler('disc-hacker:notACmd', function()
    SendNUIMessage({
        type = "NOT_A_CMD"
    })
end)

RegisterNetEvent('disc-hacker:addLine')
AddEventHandler('disc-hacker:addLine', function(line)
    SendNUIMessage({
        type = "ADD_LINE",
        data = {
            line = line
        }
    })
end)

RegisterNUICallback('Command', function(data, cb)
    data.coords = GetEntityCoords(PlayerPedId())
    local atm, atmDistance, atmCoords = FindNearestATM()
    data.atmCoords = atmCoords
    TriggerServerEvent('disc-hacker:sendCommand', data)
    cb('OK')
end)

RegisterNetEvent('disc-hacker:OpenTool')
AddEventHandler('disc-hacker:OpenTool', function()
    SendNUIMessage({
        type = "APP_SHOW"
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback('Close', function(data, cb)
    SetNuiFocus(false, false)
    cb('OK')
end)


RegisterNetEvent('disc-hacker:startHack')
AddEventHandler('disc-hacker:startHack', function(t)
    SendNUIMessage({
        type = "START_HACK",
        data = {
            hackType = t
        }
    })
end)

RegisterNetEvent('disc-hacker:distanceCheck')
AddEventHandler('disc-hacker:distanceCheck', function(coords, maxDistance, event)
    local pedCoords = GetEntityCoords(PlayerPedId())
    local distance = #(coords - pedCoords)
    if distance > maxDistance then
        TriggerServerEvent('disc-hacker:' .. event)
    end
end)