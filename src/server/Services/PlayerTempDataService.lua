--!strict

--[[
	DESCRIPTION: A module to manage the loading and unloading of temporary player data (Stamina e.t.c)
--]]

--[[
	MEMBERS:
		Profiles: A table of player temporary data

		ProfileReplicas: A table of player profile ProfileReplicas(Used for replicating the state of a player to the client and provides functions to manipulate data)

	FUNCTIONS:

	MEMBERS [ClassName]:

	METHODS [ClassName]:

	LINKS:
		https://madstudioroblox.github.io/ReplicaService/
		https://madstudioroblox.github.io/ProfileService/
]]

----------------->> SETTINGS

local Settings = {
	SaveStructure = {
		SomeData = 0,
	},
}

----------------->> SERVICES

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

----------------->> LOADED MODULES

local ProfileService = require(ReplicatedStorage.Packages.profileservice)
local ReplicaService = require(ReplicatedStorage.Packages.replicaservice)
local TableUtil = require(ReplicatedStorage.Packages["table-util"])
local Knit = require(ReplicatedStorage.Packages.knit)
local Promise = require(ReplicatedStorage.Packages.promise)
local t = require(ReplicatedStorage.Packages.t)

----------------->> MODULE

local PlayerTempDataService = Knit.CreateService({
	Name = "PlayerTempDataService",
})

----------------->> PUBLIC VARIABLES

PlayerTempDataService.Datas = {}
PlayerTempDataService.DataReplicas = {}

----------------->> PUBLIC FUNCTIONS

function PlayerTempDataService:GetData(player: Player | any)
	assert(t.instance(player) and player:IsDescendantOf(Players))

	return Promise.new(function(resolve, reject)
		repeat
			if not player:IsDescendantOf(Players) then
				reject("Player left the game")
			end
			task.wait(1)
		until PlayerTempDataService.Datas[player] ~= nil

		local Data = PlayerTempDataService.Datas[player]

		if Data ~= nil then
			resolve(Data)
		else
			reject("Data is nil")
		end
	end)
end

function PlayerTempDataService:GetDataReplica(player: Player | any)
	assert(t.instance(player) and player:IsDescendantOf(Players))

	return Promise.new(function(resolve, reject)
		repeat
			if not player:IsDescendantOf(Players) then
				reject("Player left the game")
			end
			task.wait(1)
		until PlayerTempDataService.DataReplicas[player] ~= nil

		local ProfileReplica = PlayerTempDataService.DataReplicas[player]

		if ProfileReplica ~= nil then
			if ProfileReplica:IsActive() then
				resolve(ProfileReplica)
			end
		else
			reject("ProfileReplicas is nil")
		end
	end)
end

----------------->> PRIVATE VARIABLES

----------------->> PRIVATE FUNCTIONS

local function RoundDecimalPlaces(num, decimalPlaces)
	local mult = 10 ^ (decimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

local function OnPlayerJoining(player: Player)
	local Data = TableUtil.Copy(Settings.SaveStructure)

	if player:IsDescendantOf(Players) == true then
		local DataReplica = ReplicaService.NewReplica({
			ClassToken = ReplicaService.NewClassToken("PlayerTempData"),
			Tags = { Player = player },
			Data = Data,
			Replication = "All",
		})

		PlayerTempDataService.Datas[player] = Data
		PlayerTempDataService.DataReplicas[player] = DataReplica

		warn(string.format("%s's data has been loaded", player.Name))
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

----------------->> INITIALIZE & CONNECTIONS

function PlayerTempDataService:KnitInit()
	for _, player in pairs(Players:GetPlayers()) do
		task.spawn(OnPlayerJoining, player)
	end

	Players.PlayerAdded:Connect(OnPlayerJoining)
	Players.PlayerRemoving:Connect(OnPlayerLeaving)
end

----------------->> RETURN
return PlayerTempDataService
