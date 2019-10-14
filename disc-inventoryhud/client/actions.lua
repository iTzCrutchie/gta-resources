RegisterNUICallback('UseItem', function(data)
    TriggerServerEvent('disc-inventoryhud:notifyImpendingRemoval', data.item, 1)
    TriggerServerEvent("esx:useItem", data.item.id)
    TriggerEvent('disc-inventoryhud:refreshInventory')
end)

local keys = {
    157, 158, 160, 164, 165
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        BlockWeaponWheelThisFrame()
        SetCamEffect(0)
        HideHudComponentThisFrame(19)
        HideHudComponentThisFrame(20)
        HideHudComponentThisFrame(17)
        DisableControlAction(0, 37, true) --Disable Tab
        for k, v in pairs(keys) do
            if IsDisabledControlJustReleased(0, v) then
                UseItem(k)
            end
        end
    end
end)

function UseItem(slot)
    ESX.TriggerServerCallback('disc-inventoryhud:UseItemFromSlot', function(item)
        if item then
            TriggerServerEvent('disc-inventoryhud:notifyImpendingRemoval', item, 1)
            TriggerServerEvent("esx:useItem", item.id)
        end
    end
    , slot)
end