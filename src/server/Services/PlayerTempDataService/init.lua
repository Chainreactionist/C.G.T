--!strict

--[[
{C.G.T}

-[PlayerTempDataService]---------------------------------------
	A module to manage the loading and unloading of player data.
	
	Links: IMPORTANT❗, It's essential that you understand how these modules work to efficiently use C.G.T and understand how my code works 👍

		https://madstudioroblox.github.io/ReplicaService/

		https://sleitnick.github.io/Knit/
		
		https://github.com/osyrisrblx/t

		https://eryn.io/roblox-lua-promise/docs/WhyUsePromises
	
	Members [PlayerTempDataService]:

		Datas: --> [{player_temp_data}] (Table of player datas, removed once player leaves the server and can be retrieved using PlayerTempDataService:GetData(player).)

		DataReplicas: --> [{player_temp_data_replica}] (Table of player replicas, removed once player leaves the server and can be retrieved using PlayerTempDataService:GetReplica(). It is used to replicate data to the client.)

	Methods [PlayerTempDataService]:
		
		GetData(player: Player) --> Promise<player_temp_data> (The format of Data is based on SETTINGS.SaveStructure)

		GetDataReplica(player: Player) --> Promise<player_temp_data_replica> (Use this object to edit player_temp_data)
		
--]]

local SETTINGS = {
	SaveStructure = {
		SomeData = 0,
	},
}

----- Loaded Modules -----

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local ReplicaService = require(ReplicatedStorage.Packages.replicaservice)
local TableUtil = require(ReplicatedStorage.Packages["table-util"])
local Knit = require(ReplicatedStorage.Packages.knit)
local Promise = require(ReplicatedStorage.Packages.promise)
local t = require(ReplicatedStorage.Packages.t)

----- Module Table -----

local PlayerTempDataService = Knit.CreateService({
	Name = "PlayerTempDataService",
})

----- Private Variables -----

----- Private functions -----

local function OnPlayerJoining(player: Player)
	local Data = TableUtil.Copy(SETTINGS.SaveStructure)

	if player:IsDescendantOf(Players) == true then
		local data_replica = ReplicaService.NewReplica({
			ClassToken = ReplicaService.NewClassToken("PlayerTempData"),
			Tags = { Player = player },
			Data = Data,
			Replication = "All",
		})

		PlayerTempDataService.Datas[player] = Data
		PlayerTempDataService.DataReplicas[player] = data_replica
	end
end

local function OnPlayerLeaving(player: Player)
	local Data = PlayerTempDataService.Datas[player]
	local DataReplica = PlayerTempDataService.DataReplicas[player]

	if Data ~= nil then
		PlayerTempDataService.Datas[player] = nil
	end

	if Data ~= nil then
		DataReplica:Destroy()
		PlayerTempDataService.DataReplicas[player] = nil
	end
end

----- Public -----

PlayerTempDataService.Datas = {}
PlayerTempDataService.DataReplicas = {}

function PlayerTempDataService:GetData(player: Player | any)
	assert(t.instance("Player")(player))

	return Promise.new(function(resolve, reject)
		repeat
			if not player:IsDescendantOf(Players) then
				reject("Player left the game")
			end
			task.wait(1)
		until PlayerTempDataService.Datas[player] ~= nil

		local data = PlayerTempDataService.Datas[player]

		if data ~= nil then
			resolve(data)
		else
			reject("Data is nil")
		end
	end)
end

function PlayerTempDataService:GetDataReplica(player: Player | any)
	assert(t.instance("Player")(player))

	return Promise.new(function(resolve, reject)
		repeat
			if not player:IsDescendantOf(Players) then
				reject("Player left the game")
			end
			task.wait(1)
		until PlayerTempDataService.DataReplicas[player] ~= nil

		local data_replica = PlayerTempDataService.DataReplicas[player]

		if data_replica ~= nil then
			if data_replica:IsActive() then
				resolve(data_replica)
			end
		else
			reject("ProfileReplicas is nil")
		end
	end)
end

----- Initialize & Connections -----
function PlayerTempDataService:KnitInit()
	for _, player in pairs(Players:GetPlayers()) do
		task.spawn(OnPlayerJoining, player)
	end

	Players.PlayerAdded:Connect(OnPlayerJoining)
	Players.PlayerRemoving:Connect(OnPlayerLeaving)
end

return PlayerTempDataService
