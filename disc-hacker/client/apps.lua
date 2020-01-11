RegisterNUICallback('ChangeApp', function(data, cb)
    if data.app == 'atm' then
        local obj, distance = FindNearestATM()
        if distance <= 2 then
            SendNUIMessage({
                type = "SWITCH_APP",
                data = {
                    app = 'atm',
                    message = 'ATM Found, Connecting to Network...'
                }
            })
        else
            SendNUIMessage({
                type = "SWITCH_APP",
                data = {
                    app = 'root',
                    message = 'No ATM Found!'
                }
            })
        end
    else
        SendNUIMessage({
            type = "SWITCH_APP",
            data = {
                app = 'root',
                message = 'Not a valid app: ' .. data.app
            }
        })
    end
    cb('OK')
end)

RegisterNetEvent('disc-hacker:switchApp')
AddEventHandler('disc-hacker:switchApp', function(app, message)
    SendNUIMessage({
        type = "SWITCH_APP",
        data = {
            app = app,
            message = message
        }
    })
end)