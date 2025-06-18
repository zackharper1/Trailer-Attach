
Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/trattach', 'Attach vehicle to trailer')
end)

function Notify(Text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(Text)
    DrawNotification(true, true)
end

function GetTrailer()
    local fromEntity = PlayerPedId()
    local from = GetEntityCoords(fromEntity)
    from = GetOffsetFromEntityInWorldCoords(fromEntity, 0.0, 0.0, -0.5)
    local multiplier = 1.0

    if IsPedInAnyVehicle(PlayerPedId(), false) then
        fromEntity = GetVehiclePedIsIn(PlayerPedId(), false)
        from = GetEntityCoords(fromEntity)
        multiplier = -1.0
    end

    local xCoordsToCheck = {0.0, 1.5, -1.5, 3.0, -3.0, 4.0, -4.0, 5.0, -5.0}

    for i = 1, #xCoordsToCheck do
        local to = GetOffsetFromEntityInWorldCoords(fromEntity, xCoordsToCheck[i], 10.0 * multiplier, 0)
        local rayHandle = CastRayPointToPoint(from.x, from.y, from.z, to.x, to.y, to.z, 3, PlayerPedId(), 0)
        local _, _, _, _, trailer = GetRaycastResult(rayHandle)
        if trailer ~= nil and trailer ~= 0 and trailer ~= 1 then
            return trailer
        end
    end

    Notify('~h~~r~Trailer not found!~h~~n~~w~Try to reposition yourself near the trailer at a different angle.')
    return nil
end

RegisterCommand('trattach', function(source, args, rawCommands)
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh ~= nil and veh ~= 0 and veh ~= 1 then
        local trailer = GetTrailer()
        if trailer ~= nil and trailer ~= 0 and trailer ~= 1 then
            AttachVehicleToTrailer(veh, trailer, 1.0)
        end
    end
end)
