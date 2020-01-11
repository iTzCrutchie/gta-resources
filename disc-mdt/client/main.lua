ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

local isShowing = false

RegisterCommand('mdt', function()

    if not isShowing then
        ESX.TriggerServerCallback('disc-mdt:getUser', function(user)
            SendNUIMessage({
                type = 'SET_USER',
                data = {
                    user = user
                }
            })
        end)
        ESX.TriggerServerCallback('disc-mdt:getCrimes', function(crimes)
            SendNUIMessage({
                type = "SET_CRIMES",
                data = {
                    crimes = crimes
                }
            })
        end)

        SendNUIMessage({
            type = "APP_SHOW"
        })
        SetNuiFocus(true, true)
		startAnim()
        isShowing = true
    else
        SendNUIMessage({
            type = "APP_HIDE"
        })
        stopAnim()
        DeleteObject(tab)
        SetNuiFocus(false, false)
        isShowing = false
    end
end)

local temp = false
function startAnim()
	Citizen.CreateThread(function()
    
      if not temp then
	       RequestAnimDict("amb@world_human_seat_wall_tablet@female@base")
              while not HasAnimDictLoaded("amb@world_human_seat_wall_tablet@female@base") do
                Citizen.Wait(0)
              end
		  attachObject()
		  TaskPlayAnim(GetPlayerPed(-1), "amb@world_human_seat_wall_tablet@female@base", "base" ,8.0, -8.0, -1, 50, 0, false, false, false)
          temp = true
      end
	end)
end

function attachObject()
	tab = CreateObject(GetHashKey("prop_cs_tablet"), 0, 0, 0, true, true, true)
	AttachEntityToEntity(tab, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.17, 0.10, -0.13, 20.0, 180.0, 180.0, true, true, false, true, 1, true)
end

function stopAnim()
    temp = false
	StopAnimTask(GetPlayerPed(-1), "amb@world_human_seat_wall_tablet@female@base", "base" ,8.0, -8.0, -1, 50, 0, false, false, false)
    DeleteObject(tab)
end

RegisterNUICallback("CloseUI", function(data, cb)
    isShowing = false
	stopAnim()
	DeleteObject(tab)
    SetNuiFocus(false, false)
end)

RegisterNUICallback('SetDarkMode', function(data, cb)
    TriggerServerEvent('disc-mdt:setDarkMode', data)
    cb('OK')
end)

RegisterNUICallback('GetLocation', function(data, cb)
    local player = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(player))
    local coords = { x = x, y = y, z = z }
    local var1, var2 = GetStreetNameAtCoord(x, y, z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
    street1 = GetStreetNameFromHashKey(var1)
    street2 = GetStreetNameFromHashKey(var2)
    streetName = street1
    if street2 ~= nil and street2 ~= '' then
        streetName = streetName .. ' + ' .. street2
    end
    area = GetLabelText(GetNameOfZone(x, y, z))
    SendNUIMessage({
        type = 'SET_LOCATION',
        data = {
            location = {
                street = streetName,
                area = area,
                coords = coords
            }
        }
    })
    cb('OK')
end)
