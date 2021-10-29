ARPCore = nil


NumberCharset = {}
Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

TriggerEvent("ARPCore:GetObject", function(obj) ARPCore = obj end)
RegisterServerEvent('arp-aircraft:server:takemoney', function(data)
    xPlayer = ARPCore.Functions.GetPlayer(source)
    if xPlayer.PlayerData.money['cash'] >= data.price then
        xPlayer.Functions.RemoveMoney('cash', data.price)
        TriggerClientEvent('arp-aircraft:client:spawn', source, data.model, vector3(-1592.0690, -3143.8589, 13.9449), 9.1958)
    elseif xPlayer.PlayerData.money['bank'] >= data.price then
        xPlayer.Functions.RemoveMoney('bank', data.price)
        TriggerClientEvent('arp-aircraft:client:spawn', source, data.model, vector3(-1592.0690, -3143.8589, 13.9449), 9.1958)
    else
        TriggerClientEvent('chatMessage', source, "Insufficient Funds", "error", "You don't have enough money..")
    end
end)

RegisterNetEvent('arp-aircraft:server:AddGarage')
AddEventHandler('arp-aircraft:server:AddGarage', function(vehmodel, hash)
    local src = source
    local Player = ARPCore.Functions.GetPlayer(src)
    if Player ~= nil then
        local newplate = GeneratePlate()
        newplate = newplate:gsub("%s+", "")
        exports.ghmattimysql:execute('INSERT INTO player_aircrafts (citizenid, model, plate, hanger) VALUES (@citizenid, @model, @plate, @hanger)', {
            ['@citizenid'] = Player.PlayerData.citizenid,
            ['@model'] = vehmodel,
            ['@plate'] = newplate,
            ['@hanger'] = "lsia"
        })
        TriggerClientEvent('arp-aircraft:client:AddGarage', src, newplate)
    end
end)

function GeneratePlate()
    local plate = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
    exports['ghmattimysql']:execute("SELECT * FROM `player_aircrafts` WHERE `plate` = '"..plate.."'", function(result)
        while (result[1] ~= nil) do
            plate = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
        end
        return plate
    end)
    return plate:upper()
end

function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end