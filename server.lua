RegisterServerEvent('syncTurnSignal')
AddEventHandler('syncTurnSignal', function(status, side, vehNet)
    TriggerClientEvent('syncTurnSignalClient', -1, status, side, vehNet)
end)
