local openInventory = {}

RegisterServerEvent('disc-inventoryhud:openInventory')
AddEventHandler('disc-inventoryhud:openInventory', function(inventory)
    if openInventory[inventory.owner] == nil then
        openInventory[inventory.owner] = {}
    end
    openInventory[inventory.owner][source] = true
end)

RegisterServerEvent('disc-inventoryhud:closeInventory')
AddEventHandler('disc-inventoryhud:closeInventory', function(inventory)
    if openInventory[inventory.owner] == nil then
        openInventory[inventory.owner] = {}
    end
    if openInventory[inventory.owner][source] then
        openInventory[inventory.owner][source] = nil
    end
end)

RegisterServerEvent('disc-inventoryhud:refreshInventory')
AddEventHandler('disc-inventoryhud:refreshInventory', function(owner)
    if openInventory[owner] == nil then
        openInventory[owner] = {}
    end

    for k, v in pairs(openInventory[owner]) do
        TriggerClientEvent('disc-inventoryhud:refreshInventory', k)
    end
end)

RegisterServerEvent("disc-inventoryhud:MoveToEmpty")
AddEventHandler("disc-inventoryhud:MoveToEmpty", function(data)
    local source = source
    if data.originOwner == data.destinationOwner then
        local originInvHandler = InvType[data.originTier.name]
        originInvHandler.getInventory(data.originOwner, function(inventory)
            inventory[tostring(data.destinationSlot)] = inventory[tostring(data.originSlot)]
            inventory[tostring(data.originSlot)] = nil
            originInvHandler.saveInventory(data.originOwner, inventory)
            TriggerEvent('disc-inventoryhud:refreshInventory', data.originOwner)
        end)
    else
        local originInvHandler = InvType[data.originTier.name]
        local destinationInvHandler = InvType[data.destinationTier.name]
        if data.originTier.name == 'shop' then
            local player = ESX.GetPlayerFromIdentifier(data.destinationOwner)
            if player.getMoney() >= data.originItem.price * data.originItem.qty then
                player.removeMoney(data.originItem.price * data.originItem.qty)
            else
                return
            end
        end

        if data.destinationTier.name == 'shop' then
            TriggerEvent('disc-inventoryhud:refreshInventory', data.originOwner)
            TriggerEvent('disc-inventoryhud:refreshInventory', data.destinationOwner)
            print('Attempt to sell')
            return
        end

        originInvHandler.getInventory(data.originOwner, function(originInventory)
            destinationInvHandler.getInventory(data.destinationOwner, function(destinationInventory)
                destinationInventory[tostring(data.destinationSlot)] = originInventory[tostring(data.originSlot)]
                originInventory[tostring(data.originSlot)] = nil
                destinationInvHandler.saveInventory(data.destinationOwner, destinationInventory)
                originInvHandler.saveInventory(data.originOwner, originInventory)

                TriggerEvent('disc-inventoryhud:refreshInventory', data.originOwner)
                TriggerEvent('disc-inventoryhud:refreshInventory', data.destinationOwner)

                if data.originTier.name == 'player' then
                    data.originItem.block = true
                    TriggerEvent('disc-inventoryhud:notifyImpendingRemoval', data.originItem, data.originItem.qty, source)
                    ESX.GetPlayerFromIdentifier(data.originOwner).removeInventoryItem(data.originItem.id, data.originItem.qty)
                end

                if data.destinationTier.name == 'player' then
                    data.originItem.block = true
                    TriggerEvent('disc-inventoryhud:notifyImpendingAddition', data.originItem, data.originItem.qty, source)
                    ESX.GetPlayerFromIdentifier(data.destinationOwner).addInventoryItem(data.originItem.id, data.originItem.qty)
                end

            end)
        end)
    end
end)

RegisterServerEvent("disc-inventoryhud:SwapItems")
AddEventHandler("disc-inventoryhud:SwapItems", function(data)
    local source = source

    if data.originTier.name == 'shop' then
        print('Attempt to Swap in Store')
        TriggerEvent('disc-inventoryhud:refreshInventory', data.originOwner)
        TriggerEvent('disc-inventoryhud:refreshInventory', data.destinationOwner)
        return
    end

    if data.destinationTier.name == 'shop' then
        print('Attempt to Swap in Store')
        TriggerEvent('disc-inventoryhud:refreshInventory', data.originOwner)
        TriggerEvent('disc-inventoryhud:refreshInventory', data.destinationOwner)
        return
    end

    if data.originOwner == data.destinationOwner then
        local originInvHandler = InvType[data.originTier.name]
        originInvHandler.getInventory(data.originOwner, function(inventory)
            local tempItem = inventory[tostring(data.originSlot)]
            inventory[tostring(data.originSlot)] = inventory[tostring(data.destinationSlot)]
            inventory[tostring(data.destinationSlot)] = tempItem
            originInvHandler.saveInventory(data.originOwner, inventory)
            TriggerEvent('disc-inventoryhud:refreshInventory', data.originOwner)
        end)
    else
        local originInvHandler = InvType[data.originTier.name]
        local destinationInvHandler = InvType[data.destinationTier.name]
        originInvHandler.getInventory(data.originOwner, function(originInventory)
            destinationInvHandler.getInventory(data.destinationOwner, function(destinationInventory)
                local tempItem = originInventory[tostring(data.originSlot)]
                originInventory[tostring(data.originSlot)] = destinationInventory[tostring(data.destinationSlot)]
                destinationInventory[tostring(data.destinationSlot)] = tempItem
                originInvHandler.saveInventory(data.originOwner, originInventory)
                destinationInvHandler.saveInventory(data.destinationOwner, destinationInventory)
                TriggerEvent('disc-inventoryhud:refreshInventory', data.originOwner)
                TriggerEvent('disc-inventoryhud:refreshInventory', data.destinationOwner)

                if data.originTier.name == 'player' then
                    data.originItem.block = true
                    data.destinationItem.block = true
                    TriggerEvent('disc-inventoryhud:notifyImpendingAddition', data.originItem, data.originItem.qty, source)
                    TriggerEvent('disc-inventoryhud:notifyImpendingRemoval', data.destinationItem, data.destinationItem.qty, source)
                    ESX.GetPlayerFromIdentifier(data.originOwner).addInventoryItem(data.originItem.id, data.originItem.qty)
                    ESX.GetPlayerFromIdentifier(data.originOwner).removeInventoryItem(data.destinationItem.id, data.destinationItem.qty)
                end

                if data.destinationTier.name == 'player' then
                    data.originItem.block = true
                    data.destinationItem.block = true
                    TriggerEvent('disc-inventoryhud:notifyImpendingRemoval', data.originItem, data.originItem.qty, source)
                    TriggerEvent('disc-inventoryhud:notifyImpendingAddition', data.destinationItem, data.destinationItem.qty, source)
                    ESX.GetPlayerFromIdentifier(data.destinationOwner).removeInventoryItem(data.originItem.id, data.originItem.qty)
                    ESX.GetPlayerFromIdentifier(data.destinationOwner).addInventoryItem(data.destinationItem.id, data.destinationItem.qty)
                end

            end)
        end)
    end
end)

RegisterServerEvent("disc-inventoryhud:CombineStack")
AddEventHandler("disc-inventoryhud:CombineStack", function(data)
    local source = source

    if data.originTier.name == 'shop' then
        local player = ESX.GetPlayerFromIdentifier(data.destinationOwner)
        if player.getMoney() >= data.originItem.price * data.originQty then
            player.removeMoney(data.originItem.price * data.originQty)
        else
            return
        end
    end

    if data.destinationTier.name == 'shop' then
        TriggerEvent('disc-inventoryhud:refreshInventory', data.originOwner)
        TriggerEvent('disc-inventoryhud:refreshInventory', data.destinationOwner)
        print('Attempt to sell')
        return
    end

    if data.originOwner == data.destinationOwner then
        local originInvHandler = InvType[data.originTier.name]
        originInvHandler.getInventory(data.originOwner, function(inventory)
            inventory[tostring(data.originSlot)] = nil
            inventory[tostring(data.destinationSlot)].count = data.destinationQty
            originInvHandler.saveInventory(data.originOwner, inventory)
            TriggerEvent('disc-inventoryhud:refreshInventory', data.originOwner)
        end)
    else
        local originInvHandler = InvType[data.originTier.name]
        local destinationInvHandler = InvType[data.destinationTier.name]
        originInvHandler.getInventory(data.originOwner, function(originInventory)
            destinationInvHandler.getInventory(data.destinationOwner, function(destinationInventory)
                originInventory[tostring(data.originSlot)] = nil
                destinationInventory[tostring(data.destinationSlot)].count = data.destinationQty
                originInvHandler.saveInventory(data.originOwner, originInventory)
                destinationInvHandler.saveInventory(data.destinationOwner, destinationInventory)
                TriggerEvent('disc-inventoryhud:refreshInventory', data.originOwner)
                TriggerEvent('disc-inventoryhud:refreshInventory', data.destinationOwner)

                if data.originTier.name == 'player' then
                    data.originItem.block = true
                    TriggerEvent('disc-inventoryhud:notifyImpendingRemoval', data.originItem, data.originItem.qty, source)
                    ESX.GetPlayerFromIdentifier(data.originOwner).removeInventoryItem(data.originItem.id, data.originItem.qty)
                end

                if data.destinationTier.name == 'player' then
                    data.originItem.block = true
                    TriggerEvent('disc-inventoryhud:notifyImpendingAddition', data.originItem, data.originItem.qty, source)
                    ESX.GetPlayerFromIdentifier(data.destinationOwner).addInventoryItem(data.originItem.id, data.originItem.qty)
                end
            end)
        end)
    end
end)

RegisterServerEvent("disc-inventoryhud:EmptySplitStack")
AddEventHandler("disc-inventoryhud:EmptySplitStack", function(data)

    if data.originTier.name == 'shop' then
        local player = ESX.GetPlayerFromIdentifier(data.destinationOwner)
        if player.getMoney() >= data.originItem.price * data.moveQty then
            player.removeMoney(data.originItem.price * data.moveQty)
        else
            return
        end
    end

    if data.destinationTier.name == 'shop' then
        TriggerEvent('disc-inventoryhud:refreshInventory', data.originOwner)
        TriggerEvent('disc-inventoryhud:refreshInventory', data.destinationOwner)
        print('Attempt to sell')
        return
    end

    local source = source
    if data.originOwner == data.destinationOwner then
        local originInvHandler = InvType[data.originTier.name]
        originInvHandler.getInventory(data.originOwner, function(inventory)
            inventory[tostring(data.originSlot)].count = inventory[tostring(data.originSlot)].count - data.moveQty
            local item = inventory[tostring(data.originSlot)]
            inventory[tostring(data.destinationSlot)] = {
                name = item.name,
                count = data.moveQty
            }
            originInvHandler.saveInventory(data.originOwner, inventory)
            TriggerEvent('disc-inventoryhud:refreshInventory', data.originOwner)
        end)
    else
        local originInvHandler = InvType[data.originTier.name]
        local destinationInvHandler = InvType[data.destinationTier.name]
        originInvHandler.getInventory(data.originOwner, function(originInventory)
            destinationInvHandler.getInventory(data.destinationOwner, function(destinationInventory)
                originInventory[tostring(data.originSlot)].count = originInventory[tostring(data.originSlot)].count - data.moveQty
                local item = originInventory[tostring(data.originSlot)]
                destinationInventory[tostring(data.destinationSlot)] = {
                    name = item.name,
                    count = data.moveQty
                }
                originInvHandler.saveInventory(data.originOwner, originInventory)
                destinationInvHandler.saveInventory(data.destinationOwner, destinationInventory)
                TriggerEvent('disc-inventoryhud:refreshInventory', data.originOwner)
                TriggerEvent('disc-inventoryhud:refreshInventory', data.destinationOwner)

                if data.originTier.name == 'player' then
                    data.originItem.block = true
                    TriggerEvent('disc-inventoryhud:notifyImpendingRemoval', data.originItem, data.moveQty, source)
                    ESX.GetPlayerFromIdentifier(data.originOwner).removeInventoryItem(data.originItem.id, data.moveQty)
                end

                if data.destinationTier.name == 'player' then
                    data.originItem.block = true
                    TriggerEvent('disc-inventoryhud:notifyImpendingAddition', data.originItem, data.moveQty, source)
                    ESX.GetPlayerFromIdentifier(data.destinationOwner).addInventoryItem(data.originItem.id, data.moveQty)
                end
            end)
        end)
    end
end)

RegisterServerEvent("disc-inventoryhud:SplitStack")
AddEventHandler("disc-inventoryhud:SplitStack", function(data)
    local source = source

    if data.originTier.name == 'shop' then
        local player = ESX.GetPlayerFromIdentifier(data.destinationOwner)
        if player.getMoney() >= data.originItem.price * data.moveQty then
            player.removeMoney(data.originItem.price * data.moveQty)
        else
            return
        end
    end

    if data.destinationTier.name == 'shop' then
        TriggerEvent('disc-inventoryhud:refreshInventory', data.originOwner)
        TriggerEvent('disc-inventoryhud:refreshInventory', data.destinationOwner)
        print('Attempt to sell')
        return
    end

    if data.originOwner == data.destinationOwner then
        local originInvHandler = InvType[data.originTier.name]
        originInvHandler.getInventory(data.originOwner, function(inventory)
            inventory[tostring(data.originSlot)].count = inventory[tostring(data.originSlot)].count - data.moveQty
            inventory[tostring(data.destinationSlot)].count = inventory[tostring(data.destinationSlot)].count + data.moveQty
            originInvHandler.saveInventory(data.originOwner, inventory)
            TriggerEvent('disc-inventoryhud:refreshInventory', data.originOwner)
        end)
    else
        local originInvHandler = InvType[data.originTier.name]
        local destinationInvHandler = InvType[data.destinationTier.name]
        originInvHandler.getInventory(data.originOwner, function(originInventory)
            destinationInvHandler.getInventory(data.destinationOwner, function(destinationInventory)
                originInventory[tostring(data.originSlot)].count = originInventory[tostring(data.originSlot)].count - data.moveQty
                destinationInventory[tostring(data.destinationSlot)].count = destinationInventory[tostring(data.destinationSlot)].count + data.moveQty
                originInvHandler.saveInventory(data.originOwner, originInventory)
                destinationInvHandler.saveInventory(data.destinationOwner, destinationInventory)
                TriggerEvent('disc-inventoryhud:refreshInventory', data.originOwner)
                TriggerEvent('disc-inventoryhud:refreshInventory', data.destinationOwner)

                if data.originTier.name == 'player' then
                    data.originItem.block = true
                    TriggerEvent('disc-inventoryhud:notifyImpendingRemoval', data.originItem, data.moveQty, source)
                    ESX.GetPlayerFromIdentifier(data.originOwner).removeInventoryItem(data.originItem.id, data.moveQty)
                end

                if data.destinationTier.name == 'player' then
                    data.originItem.block = true
                    TriggerEvent('disc-inventoryhud:notifyImpendingAddition', data.originItem, data.moveQty, source)
                    ESX.GetPlayerFromIdentifier(data.destinationOwner).addInventoryItem(data.originItem.id, data.moveQty)
                end
            end)
        end)
    end
end)

RegisterServerEvent("disc-inventoryhud:GiveItem")
AddEventHandler("disc-inventoryhud:GiveItem", function(data)
    local targetPlayer = ESX.GetPlayerFromId(data.target)
    targetPlayer.addInventoryItem(data.item.id, data.count)
    local sourcePlayer = ESX.GetPlayerFromId(source)
    sourcePlayer.removeInventoryItem(data.item.id, data.count)
    TriggerClientEvent('disc-inventoryhud:refreshInventory', source)
    TriggerClientEvent('disc-inventoryhud:refreshInventory', data.target)
end)

RegisterServerEvent("disc-inventoryhud:GiveCash")
AddEventHandler("disc-inventoryhud:GiveCash", function(data)
    local sourcePlayer = ESX.GetPlayerFromId(source)
    if sourcePlayer.getMoney() >= data.count then
        sourcePlayer.removeMoney(data.count)
        local targetPlayer = ESX.GetPlayerFromId(data.target)
        targetPlayer.addMoney(data.count)
        TriggerClientEvent('disc-inventoryhud:refreshInventory', source)
        TriggerClientEvent('disc-inventoryhud:refreshInventory', data.target)
    end
end)

function debugData(data)
    for k, v in pairs(data) do
        print(k .. ' ' .. v)
    end
end

function removeItemFromSlot(inventory, slot, count)
    if inventory[tostring(slot)].count - count > 0 then
        inventory[tostring(slot)].count = inventory[tostring(slot)].count - count
        return
    else
        inventory[tostring(slot)] = nil
        return
    end
end

function removeItemFromInventory(item, count, inventory)
    for k, v in pairs(inventory) do
        if v.name == item.name then
            if v.count - count < 0 then
                local tempCount = inventory[k].count
                inventory[k] = nil
                count = count - tempCount
            elseif v.count - count > 0 then
                inventory[k].count = inventory[k].count - count
                return
            elseif v.count - count == 0 then
                inventory[k] = nil
                return
            else
                print('Missing Remove condition')
            end
        end
    end
end

function addToInventory(item, type, inventory, max)
    if max == -1 then
        max = 9999
    end
    local toAdd = item.count
    while toAdd > 0 do
        toAdd = AttemptMerge(item, inventory, toAdd, max)
        if toAdd > 0 then
            toAdd = AddToEmpty(item, type, inventory, toAdd, max)
        else
            toAdd = 0
        end
    end
end

function AttemptMerge(item, inventory, count, max)
    for k, v in pairs(inventory) do
        if v.name == item.name then
            if v.count + count > max then
                local tempCount = max - inventory[k].count
                inventory[tostring(k)].count = max
                count = count - tempCount
            elseif v.count + count <= max then
                inventory[tostring(k)].count = v.count + count
                return 0
            else
                print('Missing MERGE condition')
            end
        end
    end
    return count
end

function AddToEmpty(item, type, inventory, count, max)
    for i = 1, InvType[type].slots, 1 do
        if inventory[tostring(i)] == nil then
            if count > max then
                inventory[tostring(i)] = item
                inventory[tostring(i)].count = max
                return count - max
            else
                inventory[tostring(i)] = item
                return 0
            end
        end
    end
    print('Inventory Overflow!')
    return 0
end

function createDisplayItem(item, esxItem, slot, price, type)
    local max = esxItem.limit
    if max == -1 then
        max = 9999
    end
    return {
        id = esxItem.name,
        itemId = esxItem.name,
        qty = item.count,
        slot = slot,
        label = esxItem.label,
        type = type or 'item',
        max = max,
        stackable = true,
        unique = esxItem.rare,
        usable = esxItem.usable,
        description = getItemDataProperty(esxItem.name, 'description'),
        weight = getItemDataProperty(esxItem.name, 'weight'),
        metadata = {},
        staticMeta = {},
        canRemove = esxItem.canRemove,
        price = price or 0,
        needs = false,
        closeUi = true,
    }
end

function createItem(name, count)
    return { name = name, count = count }
end

ESX.RegisterServerCallback('disc-inventoryhud:getSecondaryInventory', function(source, cb, type, identifier)
    InvType[type].getDisplayInventory(identifier, cb, source)
end)

function saveInventory(identifier, type, data)
    MySQL.Async.execute('UPDATE disc_inventory SET data = @data WHERE owner = @owner AND type = @type', {
        ['@owner'] = identifier,
        ['@type'] = type,
        ['@data'] = json.encode(data)
    }, function(result)
        if result == 0 then
            createInventory(identifier, type, data)
        end
        TriggerEvent('disc-inventoryhud:savedInventory', identifier, type, data)
    end)
end

function createInventory(identifier, type, data)
    MySQL.Async.execute('INSERT INTO disc_inventory (owner, type, data) VALUES (@owner, @type, @data)', {
        ['@owner'] = identifier,
        ['@type'] = type,
        ['@data'] = json.encode(data)
    }, function()
        TriggerEvent('disc-inventoryhud:createdInventory', identifier, type, data)
    end)
end

function deleteInventory(identifier, type)
    MySQL.Async.execute('DELETE FROM disc_inventory WHERE owner = @owner AND type = @type', {
        ['@owner'] = identifier,
        ['@type'] = type
    }, function()
        TriggerEvent('disc-inventoryhud:deletedInventory', identifier, type)
    end)
end

function getDisplayInventory(identifier, type, cb, source)
    local player = ESX.GetPlayerFromId(source)
    InvType[type].getInventory(identifier, function(inventory)
        local itemsObject = {}

        for k, v in pairs(inventory) do
            local esxItem = player.getInventoryItem(v.name)
            local item = createDisplayItem(v, esxItem, tonumber(k))
            table.insert(itemsObject, item)
        end

        local inv = {
            invId = identifier,
            invTier = InvType[type],
            inventory = itemsObject,
        }
        cb(inv)
    end)
end

function getInventory(identifier, type, cb)
    MySQL.Async.fetchAll('SELECT data FROM disc_inventory WHERE owner = @owner and type = @type', {
        ['@owner'] = identifier,
        ['@type'] = type
    }, function(result)
        if #result == 0 then
            cb({})
            return
        end
        cb(json.decode(result[1].data))
        TriggerEvent('disc-inventoryhud:gotInventory', identifier, type, result[1].data)
    end)
end
