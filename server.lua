RegisterNetEvent('syncTurnSignal')
AddEventHandler('syncTurnSignal', function(state, signalType, vehicleNetId)
    TriggerClientEvent('updateTurnSignal', -1, state, signalType, vehicleNetId)
end)
