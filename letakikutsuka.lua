-- Delete Kereta Yang Dah Meletop ( buat pe simpan? )

AddEventHandler("gameEventTriggered", function(name, args)
    if name == "CEventNetworkVehicleUndrivable" then
        local entity, destoyer, weapon = table.unpack(args)
        if DoesEntityExist(entity) and IsEntityAVehicle(entity) then
            if not IsPedAPlayer(GetPedInVehicleSeat(entity, -1)) then
                if NetworkGetEntityIsNetworked(entity) then
                    DeleteNetworkedEntity(entity)
                else
                    SetEntityAsMissionEntity(entity, false, false)
                    DeleteEntity(entity)
                end
            end
        end
    end
end)

function DeleteNetworkedEntity(entity)
    if NetworkHasControlOfEntity(entity) then
        DeleteEntity(entity)
    else
        NetworkRequestControlOfEntity(entity)
        local timeout = GetGameTimer() + 5000
        while not NetworkHasControlOfEntity(entity) and GetGameTimer() < timeout do
            Wait(100)
        end
        if NetworkHasControlOfEntity(entity) then
            DeleteEntity(entity)
        end
    end
end


-- ada issue bila dv keta ox_fuel crash  T_T (maybe ni dapat bantu lu brother)
-- ox_fuel user copy bawah ni 
-- qb-core > client > events.lua

--[[

RegisterNetEvent('QBCore:Command:DeleteVehicle', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsUsing(ped)
    if veh ~= 0 then
        for i = -1, 5, 1 do
            local seat = GetPedInVehicleSeat(veh, i)
            if seat then
                TaskLeaveVehicle(seat, veh, 0)
            end
        end
        Wait(1500)
        SetEntityAsMissionEntity(veh, true, true)
        DeleteVehicle(veh)
    else
        local pcoords = GetEntityCoords(ped)
        local vehicles = GetGamePool('CVehicle')
        for _, v in pairs(vehicles) do
            if #(pcoords - GetEntityCoords(v)) <= 5.0 then
                SetEntityAsMissionEntity(v, true, true)
                DeleteVehicle(v)
            end
        end
    end
end)

]]--
