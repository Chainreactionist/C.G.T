--!strict

--[[
	DESCRIPTION: A module to manage the loading and unloading of player data
--]]

--[[
	MEMBERS:
		ProfileStore: Return of DataStoreService:GetDataStore equivelent in the ProfileService module

		Profiles: A table of player profiles(An abstraction of player data.)

		ProfileReplicas: A table of player profile ProfileReplicas(Used for replicating the state of a player to the client and provides functions to manipulate data)

		GlobalUpdateHandlers: A folder of modulescripts that should return a function that is called to handle global updates

	FUNCTIONS:

	MEMBERS [ClassName]:

	METHODS [ClassName]:
		GetProfile: Returns a player profile

		GetData: Returns a PlayerProfile.Data table

		GetDataReplica: Returns a player replica which allows for the modifying of playerdata

	LINKS:
		https://madstudioroblox.github.io/ReplicaService/

		https://madstudioroblox.github.io/ProfileService/

		https://sleitnick.github.io/Knit/
		
		https://github.com/osyrisrblx/t

		https://eryn.io/roblox-lua-promise/
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local ProfileService = require(ReplicatedStorage.Packages.profileservice)
local ReplicaService = require(ReplicatedStorage.Packages.replicaservice)
local Knit = require(ReplicatedStorage.Packages.knit)
local Promise = require(ReplicatedStorage.Packages.promise)
local t = require(ReplicatedStorage.Packages.t)

--Reconsider using T

type UpdateData = { Id: string, SenderId: number, RecieverId: number, Data: {} }

local Settings = {
	MockProfiles = false,
	SaveStructure = {
		SomeData = 0,
	},
}

local Types = {
	UpdateData = t.strictInterface({
		Id = t.string,
		SenderId = t.number,
		RecieverId = t.number,
		Data = t.optional(t.table),
	}),
}

----------------->> SERVICES

----------------->> LOADED MODULES

----------------->> MODULE

local PlayerDataService = Knit.CreateService({
	Name = "PlayerDataService",
})

----------------->> PRIVATE VARIABLES
----------------->> PRIVATE FUNCTION

local function OnPlayerJoining(player: Player)
	local PlayerProfile

	if RunService:IsStudio() and Settings.MockProfiles then
		PlayerProfile = PlayerDataService.ProfileStore.Mock:LoadProfileAsync("Player_" .. tostring(player.UserId))
	else
		PlayerProfile = PlayerDataService.ProfileStore:LoadProfileAsync("Player_" .. tostring(player.UserId))
	end

	if PlayerProfile ~= nil then
		PlayerProfile:AddUserId(player.UserId)
		PlayerProfile:Reconcile()
		PlayerProfile:ListenToRelease(function()
			PlayerDataService.Profiles[player] = nil
			player:Kick()
		end)

		if player:IsDescendantOf(Players) == true then
			local ProfileReplica = ReplicaService.NewReplica({
				ClassToken = ReplicaService.NewClassToken("PlayerData"),
				Tags = { Player = player },
				Data = PlayerProfile.Data,
				Replication = "All",
			})

			PlayerDataService.Profiles[player] = PlayerProfile
			PlayerDataService.ProfileReplicas[player] = ProfileReplica

			local function OnActiveGlobalUpdate(UpdateId: number, UpdateData: UpdateData)
				assert(t.number(UpdateId) and Types.UpdateData(UpdateData))

				PlayerProfile.GlobalUpdates:LockActiveUpdate(UpdateId)
			end

			local function OnLockedGlobalUpdate(UpdateId: number, UpdateData: UpdateData)
				assert(t.number(UpdateId) and Types.UpdateData(UpdateData))

				local LockedUpdateHandler = PlayerDataService.GlobalUpdateHandlers:FindFirstChild(UpdateData.Id)

				if LockedUpdateHandler then
					Promise.try(require(LockedUpdateHandler), UpdateId, UpdateData)
						:andThen(function()
							PlayerProfile.GlobalUpdates:ClearLockedUpdate(UpdateId)
						end)
						:catch(warn)
						:await()
				else
					warn("GlobalUpdateHandler not found")
				end
			end

			for _, ActiveUpdate in pairs(PlayerProfile.GlobalUpdates:GetActiveUpdates()) do
				OnActiveGlobalUpdate(ActiveUpdate[1], ActiveUpdate[2])
			end

			for _, LockedUpdate in pairs(PlayerProfile.GlobalUpdates:GetLockedUpdates()) do
				task.spawn(OnLockedGlobalUpdate, LockedUpdate[1], LockedUpdate[2])
			end

			PlayerProfile.GlobalUpdates:ListenToNewActiveUpdate(OnActiveGlobalUpdate)
			PlayerProfile.GlobalUpdates:ListenToNewLockedUpdate(OnLockedGlobalUpdate)
		else
			PlayerProfile:Release()
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
	end
end

----------------->> PUBLIC VARIABLES

PlayerDataService.ProfileStore = ProfileService.GetProfileStore("PlayerData", Settings.SaveStructure)
PlayerDataService.GlobalUpdateHandlers = ServerScriptService.Server.GlobalUpdateHandlers
PlayerDataService.Profiles = {}
PlayerDataService.ProfileReplicas = {}

----------------->> PUBLIC FUNCTIONS

function PlayerDataService:GetProfile(player: Player | any)
	assert(t.instance("Player")(player))

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

function PlayerDataService:GetData(player: Player | any)
	assert(t.instance("Player")(player))

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

function PlayerDataService:GetDataReplica(player: Player | any)
	assert(t.instance("Player")(player))

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

function PlayerDataService:AddGlobalUpdate(UpdateData: UpdateData)
	Types.UpdateData(UpdateData)

	return Promise.new(function(resolve, reject)
		PlayerDataService.ProfileStore:GlobalUpdateProfileAsync(
			"Player_" .. tostring(UpdateData.RecieverId),
			function(globalUpdates)
				globalUpdates:AddActiveUpdate(UpdateData)
			end
		)
		resolve()
	end)
end

----------------->> INITIALIZE & CONNECTIONS

function PlayerDataService:KnitInit()
	for _, player in pairs(Players:GetPlayers()) do
		task.spawn(OnPlayerJoining, player)
	end

	ProfileService.IssueSignal:Connect(function(error_message, profile_store_name, profile_key)
		warn(string.format("ProfileServiceIssue %s %s %s", error_message, profile_store_name, profile_key))
	end)

	Players.PlayerAdded:Connect(OnPlayerJoining)
	Players.PlayerRemoving:Connect(OnPlayerLeaving)
end

----------------->> CONNECTIONS

----------------->> RETURN

return PlayerDataService
