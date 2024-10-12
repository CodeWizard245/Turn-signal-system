local isLeftTurnSignalOn = false
local isRightTurnSignalOn = false
local isHazardLightsOn = false
local turnSignalSoundTimer = nil
local config = {
    leftTurnKey = 174,
    rightTurnKey = 175,
    hazardLightsKey = 178
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == playerPed then
            if IsControlJustPressed(0, config.leftTurnKey) and not isHazardLightsOn then
                isLeftTurnSignalOn = not isLeftTurnSignalOn
                SetVehicleIndicatorLights(vehicle, 1, isLeftTurnSignalOn)
                TriggerServerEvent('syncTurnSignal', isLeftTurnSignalOn, 'left', VehToNet(vehicle))
                if isLeftTurnSignalOn then
                    StartTurnSignalSound(vehicle)
                else
                    StopTurnSignalSound()
                end
                if isLeftTurnSignalOn then
                    isRightTurnSignalOn = false
                    SetVehicleIndicatorLights(vehicle, 0, false)
                    TriggerServerEvent('syncTurnSignal', isRightTurnSignalOn, 'right', VehToNet(vehicle))
                end
            end

            if IsControlJustPressed(0, config.rightTurnKey) and not isHazardLightsOn then
                isRightTurnSignalOn = not isRightTurnSignalOn
                SetVehicleIndicatorLights(vehicle, 0, isRightTurnSignalOn)
                TriggerServerEvent('syncTurnSignal', isRightTurnSignalOn, 'right', VehToNet(vehicle))
                if isRightTurnSignalOn then
                    StartTurnSignalSound(vehicle)
                else
                    StopTurnSignalSound()
                end
                if isRightTurnSignalOn then
                    isLeftTurnSignalOn = false
                    SetVehicleIndicatorLights(vehicle, 1, false)
                    TriggerServerEvent('syncTurnSignal', isLeftTurnSignalOn, 'left', VehToNet(vehicle))
                end
            end

            if IsControlJustPressed(0, config.hazardLightsKey) then
                isHazardLightsOn = not isHazardLightsOn
                isLeftTurnSignalOn = isHazardLightsOn
                isRightTurnSignalOn = isHazardLightsOn

                SetVehicleIndicatorLights(vehicle, 0, isRightTurnSignalOn)
                SetVehicleIndicatorLights(vehicle, 1, isLeftTurnSignalOn)
                TriggerServerEvent('syncTurnSignal', isLeftTurnSignalOn, 'left', VehToNet(vehicle))
                TriggerServerEvent('syncTurnSignal', isRightTurnSignalOn, 'right', VehToNet(vehicle))

                if isHazardLightsOn then
                    StartTurnSignalSound(vehicle)
                else
                    StopTurnSignalSound()
                end
            end
        else
            StopTurnSignalSound()
        end
    end
end)

function StartTurnSignalSound(vehicle)
    if turnSignalSoundTimer == nil then
        turnSignalSoundTimer = true

        Citizen.CreateThread(function()
            while turnSignalSoundTimer do
                PlaySoundFromEntity(-1, "BLINKER_ON", vehicle, "DLC_HEISTS_GENERAL_ENTRY_SOUNDS", 0, 0)
                Citizen.Wait(500)
            end
        end)
    end
end

function StopTurnSignalSound()
    if turnSignalSoundTimer ~= nil then
        turnSignalSoundTimer = nil
        PlaySoundFromEntity(-1, "BLINKER_OFF", GetVehiclePedIsIn(PlayerPedId(), false), "DLC_HEISTS_GENERAL_ENTRY_SOUNDS", 0, 0)
    end
end

RegisterNetEvent('syncTurnSignalClient')
AddEventHandler('syncTurnSignalClient', function(status, side, vehNet)
    local vehicle = NetToVeh(vehNet)
    if vehicle and DoesEntityExist(vehicle) then
        if side == 'left' then
            SetVehicleIndicatorLights(vehicle, 1, status)
        elseif side == 'right' then
            SetVehicleIndicatorLights(vehicle, 0, status)
        end
    end
end)
