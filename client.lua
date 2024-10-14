local isLeftTurnSignalOn = false
local isRightTurnSignalOn = false
local isHazardLightsOn = false

function ToggleLeftTurnSignal()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        isLeftTurnSignalOn = not isLeftTurnSignalOn
        SetVehicleIndicatorLights(vehicle, 1, isLeftTurnSignalOn)
        TriggerServerEvent('syncTurnSignal', isLeftTurnSignalOn, 'left', VehToNet(vehicle))
    end
end

function ToggleRightTurnSignal()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        isRightTurnSignalOn = not isRightTurnSignalOn
        SetVehicleIndicatorLights(vehicle, 0, isRightTurnSignalOn)
        TriggerServerEvent('syncTurnSignal', isRightTurnSignalOn, 'right', VehToNet(vehicle))
    end
end

function ToggleHazardLights()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        isHazardLightsOn = not isHazardLightsOn
        SetVehicleIndicatorLights(vehicle, 0, isHazardLightsOn)
        SetVehicleIndicatorLights(vehicle, 1, isHazardLightsOn)
        TriggerServerEvent('syncTurnSignal', isHazardLightsOn, 'left', VehToNet(vehicle))
        TriggerServerEvent('syncTurnSignal', isHazardLightsOn, 'right', VehToNet(vehicle))
    end
end

RegisterNetEvent('updateTurnSignal')
AddEventHandler('updateTurnSignal', function(state, signalType, vehicleNetId)
    local vehicle = NetToVeh(vehicleNetId)
    if DoesEntityExist(vehicle) then
        if signalType == 'left' then
            SetVehicleIndicatorLights(vehicle, 1, state)
        elseif signalType == 'right' then
            SetVehicleIndicatorLights(vehicle, 0, state)
        end
    end
end)

RegisterCommand('leftSignal', function()
    ToggleLeftTurnSignal()
end, false)

RegisterCommand('rightSignal', function()
    ToggleRightTurnSignal()
end, false)

RegisterCommand('hazardLights', function()
    ToggleHazardLights()
end, false)

RegisterKeyMapping('leftSignal', 'Left turn signal', 'keyboard', 'LEFT')
RegisterKeyMapping('rightSignal', 'Right turn signal ', 'keyboard', 'RIGHT')
RegisterKeyMapping('hazardLights', 'Emergency alarm', 'keyboard', 'DEL')
