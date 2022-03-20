--!strict

--[[
	DESCRIPTION: A module to manage the loading and unloading of player data
--]]

--[[
	MEMBERS:
		PlayerProfileStore: Return of DataStoreService:GetDataStore equivelent in the ProfileService module

		Profiles: A table of player profiles(An abstraction of player data.)

		ProfileReplicas: A table of player profile ProfileReplicas(Used for replicating the state of a player to the client and provides functions to manipulate data)

	FUNCTIONS:

	MEMBERS [ClassName]:

	METHODS [ClassName]:
		GetPlayerDataProfile: Returns a player profile which consists of their data and metadata
		GetPlayerDataReplica: Returns a player replica which allows for the modifying of playerdata

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
local Knit = require(ReplicatedStorage.Packages.knit)
local Promise = require(ReplicatedStorage.Packages.promise)

----------------->> MODULE

local PlayerDataService = Knit.CreateService({
	Name = "PlayerDataService",
})

----------------->> PUBLIC VARIABLES

PlayerDataService.PlayerProfileStore = ProfileService.GetProfileStore("PlayerData", Settings.SaveStructure)
PlayerDataService.Profiles = {}
PlayerDataService.ProfileReplicas = {}

----------------->> PUBLIC FUNCTIONS

function PlayerDataService:GetProfile(player: Player)
	assert(typeof(player) == "Instance" and player:IsDescendantOf(Players), "player is not of type player")

	return Promise.new(function(resolve, reject)
		repeat
			if not player:IsDescendantOf(Players) then
				reject("Player left the game")
			end
			task.wait(1)
		until PlayerDataService.Profiles[player] ~= nil

		local Profile = PlayerDataService.Profiles[player]

		if Profile ~= nil then
			if Profile:IsActive() then
				resolve(Profile)
			end
		else
			reject("Profile is nil")
		end

		reject("Player left the game")
	end)
end

function PlayerDataService:GetData(player: Player)
	assert(typeof(player) == "Instance" and player:IsDescendantOf(Players), "player is not of type player")

	return Promise.new(function(resolve, reject)
		repeat
			if not player:IsDescendantOf(Players) then
				reject("Player left the game")
			end
			task.wait(1)
		until PlayerDataService.Profiles[player] ~= nil

		local Profile = PlayerDataService.Profiles[player]

		if Profile ~= nil then
			if Profile:IsActive() then
				resolve(Profile.Data)
			end
		else
			reject("Profile is nil")
		end

		reject("Player left the game")
	end)
end

function PlayerDataService:GetDataReplica(player: Player)
	assert(typeof(player) == "Instance" and player:IsDescendantOf(Players), "player is not of type player")

	return Promise.new(function(resolve, reject)
		repeat
			if not player:IsDescendantOf(Players) then
				reject("Player left the game")
			end
			task.wait(1)
		until PlayerDataService.ProfileReplicas[player] ~= nil

		local ProfileReplica = PlayerDataService.ProfileReplicas[player]

		if ProfileReplica ~= nil then
			if ProfileReplica:IsActive() then
				resolve(ProfileReplica)
			end
		else
			reject("ProfileReplicas is nil")
		end

		reject("Player left the game")
	end)
end

----------------->> PRIVATE VARIABLES
----------------->> PRIVATE FUNCTIONS

local function RoundDecimalPlaces(num, decimalPlaces)
	local mult = 10 ^ (decimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

local function OnPlayerJoining(player: Player)
	local ProfileLoadStartTime = tick()
	local Profile

	if RunService:IsStudio() then
		Profile = PlayerDataService.PlayerProfileStore.Mock:LoadProfileAsync("Player_" .. tostring(player.UserId))
	else
		Profile = PlayerDataService.PlayerProfileStore:LoadProfileAsync("Player_" .. tostring(player.UserId))
	end

	if Profile ~= nil then
		Profile:AddUserId(player.UserId)
		Profile:Reconcile()
		Profile:ListenToRelease(function()
			PlayerDataService.Profiles[player] = nil
			player:Kick()
		end)

		if player:IsDescendantOf(Players) == true then
			local ProfileLoadStopTime = tick()
			local ProfileReplica = ReplicaService.NewReplica({
				ClassToken = ReplicaService.NewClassToken("ProfileReplica"),
				Data = Profile.Data,
				Replication = "All",
			})

			PlayerDataService.Profiles[player] = Profile
			PlayerDataService.ProfileReplicas[player] = ProfileReplica

			warn(
				string.format(
					"%s's data has been loaded (%s)",
					player.Name,
					tostring(RoundDecimalPlaces(ProfileLoadStopTime - ProfileLoadStartTime, 5))
				)
			)
		else
			Profile:Release()
		end
	else
		player:Kick()
	end
end

local function OnPlayerLeaving(player: Player)
	local Profile = PlayerDataService.Profiles[player]
	local ProfileReplica = PlayerDataService.ProfileReplicas[player]

	if Profile ~= nil then
		Profile:Release()
		PlayerDataService.Profiles[player] = nil
		warn(string.format("%s's profile has been released", player.Name))
	end

	if ProfileReplica ~= nil then
		ProfileReplica:Destroy()
		PlayerDataService.ProfileReplicas[player] = nil
		warn(string.format("%s's replica has been destroyed", player.Name))
	end
end

----------------->> INITIALIZE & CONNECTIONS

function PlayerDataService:KnitInit()
	for _, player in pairs(Players:GetPlayers()) do
		task.spawn(OnPlayerJoining, player)
	end

	Players.PlayerAdded:Connect(OnPlayerJoining)
	Players.PlayerRemoving:Connect(OnPlayerLeaving)
end

----------------->> CONNECTIONS

----------------->> RETURN

return PlayerDataService
