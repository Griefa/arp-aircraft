ARPCore = nil

Citizen.CreateThread(function()
    while ARPCore == nil do
        TriggerEvent('ARPCore:GetObject', function(obj) ARPCore = obj end)
        Citizen.Wait(200)
    end
end)

local cam
local lastpos
--local veh
PlayerJob = {}

RegisterNetEvent('ARPCore:Client:OnPlayerLoaded')
AddEventHandler('ARPCore:Client:OnPlayerLoaded', function()
    ARPCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
    end)
end)

RegisterNetEvent('ARPCore:Client:OnJobUpdate')
AddEventHandler('ARPCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

AddEventHandler('onClientResourceStart',function()
    Citizen.CreateThread(function()
        while true do
            if ARPCore ~= nil and ARPCore.Functions.GetPlayerData ~= nil then
                ARPCore.Functions.GetPlayerData(function(PlayerData)
                    if PlayerData.job then
                        PlayerJob = PlayerData.job
                    end
                end)
                break
            end
            Citizen.Wait(500)
        end
        Citizen.Wait(500)
    end)
end)

CreateThread(function()
    while true do
        Citizen.Wait(3)
        if PlayerJob.name == "police" then
            local inRange = false
            local pos = GetEntityCoords(PlayerPedId())
            local coords = vector3(-1628.5302, -3159.9749, 13.9918)

            if #(pos - coords) < 2.5 then
                inRange = true
                DrawText3D(-1628.5302, -3159.9749, 13.9918 , '~g~[E]~s~ - Access Aircraft Catalogue')
                if IsControlJustPressed(0, 38) then
                    TriggerEvent("arp-aircraft:openUI")
                end
            end

            if not inRange then
                Citizen.Wait(2000)
            end
        else
            Citizen.Wait(10000)
        end
    end
end)

function openUI(data,index,cb)
    local plyPed = PlayerPedId()
    lastpos = GetEntityCoords(plyPed)
    SetEntityCoords(plyPed, -1628.5302, -3159.9749, 13.9918)
    SetEntityVisible(plyPed, false)
    SetNuiFocus(true, true)
end

RegisterNUICallback("showVeh", function(data,cb)
    -- CLEAR SPACE
    local vehinarea = ARPCore.Functions.GetVehiclesInArea(vector3(-1652.4353, -3143.1526, 13.9921), 1)
    if #vehinarea ~= 0 then
        ARPCore.Functions.DeleteVehicle(vehinarea[1])
    end

    -- SPAWN VEHICLE
    ARPCore.Functions.SpawnVehicle(data.model, function(veh)
        SetEntityCoords(veh, -1652.4353, -3143.1526, 13.9921)
        SetEntityHeading(veh, 331.2454)
        SetEntityAlpha(veh, 85)
    end)
end)

RegisterNetEvent("arp-aircraft:client:spawn",function(model,spawnLoc,spawnHeading)
    -- CLEAR SPACE
    local vehinarea = ARPCore.Functions.GetVehiclesInArea(vector3(-1652.4353, -3143.1526, 13.9921), 1)
    if #vehinarea ~= 0 then
        ARPCore.Functions.DeleteVehicle(vehinarea[1])
    end

    -- SPAWN VEHICLE
    ARPCore.Functions.SpawnVehicle(model, function(veh)
        SetEntityCoords(veh, spawnLoc.x, spawnLoc.y, spawnLoc.z)
        SetEntityHeading(veh, spawnHeading)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
        -- ADD GARGE
        local props = ARPCore.Functions.GetVehicleProperties(veh)
        local hash = props.model
        TriggerServerEvent('arp-aircraft:server:AddGarage', model, hash)
    end)
end)

RegisterNetEvent('arp-aircraft:client:AddGarage')
AddEventHandler('arp-aircraft:client:AddGarage',function(plate)
    local veh = GetVehiclePedIsIn(PlayerPedId())
    SetVehicleNumberPlateText(veh, plate:gsub("%s+", ""))
end)

RegisterNUICallback("buy", function(data,cb)
    SendNUIMessage({
        action = 'close'
    })
    TriggerServerEvent('arp-aircraft:server:takemoney', data)
    SetEntityCoords(PlayerPedId(), lastpos.x, lastpos.y, lastpos.z)
    SetEntityVisible(PlayerPedId(), true)
    local vehinarea = ARPCore.Functions.GetVehiclesInArea(vector3(-1592.0690, -3143.8589, 13.9449), 9.1958)
    if #vehinarea ~= 0 then
        ARPCore.Functions.DeleteVehicle(vehinarea[1])
    end
    DoScreenFadeOut(500)
    Wait(500)
    RenderScriptCams(false, false, 1, true, true)
    DestroyAllCams(true)
    SetNuiFocus(false, false)
    DoScreenFadeIn(500)
    Wait(500)
end)

RegisterNUICallback("close", function()
    SetEntityCoords(PlayerPedId(), lastpos.x, lastpos.y, lastpos.z)
    SetEntityVisible(PlayerPedId(), true)
    local vehinarea = ARPCore.Functions.GetVehiclesInArea(vector3(-1592.0690, -3143.8589, 13.9449), 9.1958)
    if #vehinarea ~= 0 then
        ARPCore.Functions.DeleteVehicle(vehinarea[1])
    end
    DoScreenFadeOut(500)
    Wait(500)
    RenderScriptCams(false, false, 1, true, true)
    DestroyAllCams(true)
    SetNuiFocus(false, false)
    DoScreenFadeIn(500)
    Wait(500)
end)

RegisterNetEvent("arp-aircraft:openUI",function()
    changeCam()
    for i = 1,#Config.Garage do
        SendNUIMessage({
            action = true,
            index = i,
            vehicleInfo = Config.Garage[i].vehicles
        })
        openUI(Config.Garage[i].vehicles, i)
    end
end)

function changeCam()
    DoScreenFadeOut(500)
    Wait(1000)
    if not DoesCamExist(cam) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    end
    SetCamActive(cam, true)
    SetCamRot(cam,vector3(-10.0,0.0, -155.999), true)
    SetCamFov(cam,70.0)
    SetCamCoord(cam, vector3(-1645.5231, -3148.0344, 13.9922))
    PointCamAtCoord(cam,vector3(-1646.4617, -3147.4492, 13.9922))
    RenderScriptCams(true, false, 2500.0, true, true)
    DoScreenFadeIn(1000)
    Wait(1000)
end

DrawText3D = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end