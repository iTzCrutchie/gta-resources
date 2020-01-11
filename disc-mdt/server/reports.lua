ESX.RegisterServerCallback('disc-mdt:postReport', function(source, cb, data)
    local report = {
        area = data.location.area,
        street = data.location.street,
        coords = data.location.coords,
        date = data.date,
        time = data.time,
        notes = data.notes,
        crimes = data.crimes,
    }
    MySQL.Async.execute('INSERT INTO disc_mdt_reports (officerIdentifier, playerIdentifier, report, date, time) VALUES (@officerIdentifier, @playerIdentifier, @report, @date, @time)', {
        ['@officerIdentifier'] = data.form.officerIdentifier,
        ['@playerIdentifier'] = data.form.playerIdentifier,
        ['@report'] = json.encode(report),
        ['@date'] = data.date,
        ['@time'] = data.time,
    }, function()
        cb(true)
    end)
end)

ESX.RegisterServerCallback('disc-mdt:searchReports', function(source, cb, search)
    MySQL.Async.fetchAll([[
        SELECT reports.*,
            DATE_FORMAT(reports.date, '%d-%m-%Y') as stringDate,
            DATE_FORMAT(reports.time, '%H:%i') as stringTime,
            concat(ou.firstname ,' ' ,ou.lastname) as officerName, concat(pu.firstname ,' ' ,pu.lastname) as playerName
            FROM disc_mdt_reports reports
            JOIN users ou on ou.identifier = reports.officeridentifier
            JOIN users pu on pu.identifier = reports.playeridentifier
            WHERE reports.id=@id OR pu.firstname LIKE @search OR pu.lastname LIKE @search
    ]], {
        ['@id'] = string.sub(search, 2),
        ['@search'] = '%' .. search .. '%'
    }, function(results)
        for k, v in ipairs(results) do
            results[k].report = json.decode(v.report)
        end
        cb(results)
    end)
end)

ESX.RegisterServerCallback('disc-mdt:getOfficerReports', function(source, cb)
    local player = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll([[SELECT reports.*, concat(ou.firstname ,' ' ,OU.lastname) as officerName, concat(pu.firstname ,' ' ,pu.lastname) as playerName FROM disc_mdt_reports reports
                            join users ou on ou.identifier = reports.officeridentifier
                            join users pu on pu.identifier = reports.playeridentifier
                            where reports.officeridentifier=@identifier order by date, time LIMIT 50]], {
        ['@identifier'] = player.identifier
    }, function(results)
        cb(results)
    end)
end)

ESX.RegisterServerCallback('disc-mdt:getReportsForPlayer', function(source, cb, identifier)
    MySQL.Async.fetchAll([[SELECT reports.*,
                            DATE_FORMAT(reports.date, '%d-%m-%Y') as stringDate,
                            DATE_FORMAT(reports.time, '%H:%i') as stringTime,
                            concat(ou.firstname ,' ' ,ou.lastname) as officerName, concat(pu.firstname ,' ' ,pu.lastname) as playerName FROM disc_mdt_reports reports
                            join users ou on ou.identifier = reports.officeridentifier
                            join users pu on pu.identifier = reports.playeridentifier
                            where reports.playeridentifier=@identifier order by date DESC, time DESC LIMIT 5]], {
        ['@identifier'] = identifier
    }, function(results)
        for k, v in ipairs(results) do
            results[k].report = json.decode(v.report)
        end
        cb(results)
    end)
end)
