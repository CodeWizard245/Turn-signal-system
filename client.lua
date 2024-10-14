local isLeftTurnSignalOn = false
local isRightTurnSignalOn = false
local isHazardLightsOn = false

function IsPlayerDriver()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    return (vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == PlayerPedId())
end

function ToggleLeftTurnSignal()
    if not IsPlayerDriver() then
        return
    end

    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        if isRightTurnSignalOn then
            isRightTurnSignalOn = false
            SetVehicleIndicatorLights(vehicle, 0, false)
            TriggerServerEvent('syncTurnSignal', false, 'right', VehToNet(vehicle))
        end

        isLeftTurnSignalOn = not isLeftTurnSignalOn
        SetVehicleIndicatorLights(vehicle, 1, isLeftTurnSignalOn)
        TriggerServerEvent('syncTurnSignal', isLeftTurnSignalOn, 'left', VehToNet(vehicle))
    end
end

function ToggleRightTurnSignal()
    if not IsPlayerDriver() then
        return
    end

    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        if isLeftTurnSignalOn then
            isLeftTurnSignalOn = false
            SetVehicleIndicatorLights(vehicle, 1, false)
            TriggerServerEvent('syncTurnSignal', false, 'left', VehToNet(vehicle))
        end

        isRightTurnSignalOn = not isRightTurnSignalOn
        SetVehicleIndicatorLights(vehicle, 0, isRightTurnSignalOn)
        TriggerServerEvent('syncTurnSignal', isRightTurnSignalOn, 'right', VehToNet(vehicle))
    end
end

function ToggleHazardLights()
    if not IsPlayerDriver() then
        return
    end

    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        isLeftTurnSignalOn = false
        isRightTurnSignalOn = false
        SetVehicleIndicatorLights(vehicle, 0, false)
        SetVehicleIndicatorLights(vehicle, 1, false)
        TriggerServerEvent('syncTurnSignal', false, 'left', VehToNet(vehicle))
        TriggerServerEvent('syncTurnSignal', false, 'right', VehToNet(vehicle))

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