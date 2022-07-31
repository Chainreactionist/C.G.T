--!strict

--[[
{C.G.T}

-[PlayerDataService]---------------------------------------
	A module to manage the loading and unloading of player data.
	
	Links: IMPORTANT❗, It's essential that you understand how these modules work to efficiently use C.G.T and understand how my code works 👍

		https://madstudioroblox.github.io/ReplicaService/

		https://madstudioroblox.github.io/ProfileService/

		https://sleitnick.github.io/Knit/
		
		https://github.com/osyrisrblx/t

		https://eryn.io/roblox-lua-promise/docs/WhyUsePromises
	
	Members [PlayerDataService]:

		ProfileStore: --> [ProfileStore] (To view a player's date through DataStoreEditor "PlayerData" --> "Player_"..UserId (Player_1).)

		GlobalUpdateHandlers: --> [Folder] (To handle a new sort of Update you need to add a module to this folder that returns the handler function.)

		Profiles: --> [{player_profile}] (Table of player profiles, removed once player leaves the server and can be retrieved using PlayerDataService:GetProfile().)

		Replicas: --> [{player_profile_Replica}] (Table of player replicas, removed once player leaves the server and can be retrieved using PlayerDataService:GetReplica(). It is used to replicate data to the client.)

	Methods [PlayerDataService]:
		
		GetProfile(player: Player) --> Promise<player_profile>

		GetData(player: Player) --> Promise<player_profile.Data> (The format of Profile.Data is based on SETTINGS.SaveStructure)

		GetDataReplica(player: Player) --> Promise<Replica> (Use this object to edit player data)
		
		AddGlobalUpdate(UpdateData: { Id: string, SenderId: number, ReceiverId: number, Data: {} }) GlobalUpdates are used to send info to players across servers and regardless of whether or not they are online.

--]]

----- Loaded Modules -----

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local ProfileService = require(ReplicatedStorage.Packages.profileservice)
local ReplicaService = require(ReplicatedStorage.Packages.replicaservice)
local Knit = require(ReplicatedStorage.Packages.knit)
local Promise = require(ReplicatedStorage.Packages.promise)
local t = require(ReplicatedStorage.Packages.t)

local SETTINGS = {
	MockProfiles = false,
	ClassToken = ReplicaService.NewClassToken("PlayerData"),
	SaveStructure = {
		SomeData = 0,
	},
}

type UpdateData = { Id: string, SenderId: number, TimeSent: number, ReceiverId: number, Data: {} }

----- Module Table -----

local PlayerDataService = Knit.CreateService({
	Name = "PlayerDataService",
	ProfileStore = ProfileService.GetProfileStore("PlayerData", SETTINGS.SaveStructure),
	Profiles = {},
	ProfileDataReplicas = {},
})

----- Private Variables -----

local TYPES = {
	UpdateData = t.strictInterface({
		Id = t.string,
		SenderId = t.number,
		ReceiverId = t.number,
		TimeSent = t.number,
		Data = t.optional(t.table),
	}),
}

local GlobalUpdateHandlers = script.GlobalUpdateHandlers
local ProfileServiceErrorHandlers = script.ProfileServiceErrorHandlers

----- Private functions -----

local function OnPlayerJoining(player: Player)
	local player_profile

	if RunService:IsStudio() and SETTINGS.MockProfiles then
		player_profile = PlayerDataService.ProfileStore.Mock:LoadProfileAsync("Player_" .. tostring(player.UserId))
	else
		player_profile = PlayerDataService.ProfileStore:LoadProfileAsync("Player_" .. tostring(player.UserId))
	end

	if player_profile ~= nil then
		player_profile:AddUserId(player.UserId)
		player_profile:Reconcile()
		player_profile:ListenToRelease(function()
			PlayerDataService.Profiles[player] = nil

			local ProfileReplica = PlayerDataService.ProfileDataReplicas[player]

			if ProfileReplica ~= nil then
				ProfileReplica:Destroy()
				PlayerDataService.ProfileDataReplicas[player] = nil
			end
			player:Kick()
		end)

		if player:IsDescendantOf(Players) == true then
			local ProfileReplica = ReplicaService.NewReplica({
				ClassToken = SETTINGS.ClassToken,
				Tags = { Player = player },
				Data = player_profile.Data,
				Replication = "All",
			})

			PlayerDataService.Profiles[player] = player_profile
			PlayerDataService.ProfileDataReplicas[player] = ProfileReplica

			local function OnActiveGlobalUpdate(UpdateId: number, UpdateData: UpdateData)
				assert(t.number(UpdateId) and TYPES.UpdateData(UpdateData))

				player_profile.GlobalUpdates:LockActiveUpdate(UpdateId)
			end

			local function OnLockedGlobalUpdate(UpdateId: number, UpdateData: UpdateData)
				assert(t.number(UpdateId) and TYPES.UpdateData(UpdateData))

				local LockedUpdateHandler = GlobalUpdateHandlers:FindFirstChild(UpdateData.Id)

				if LockedUpdateHandler then
					Promise.try(require(LockedUpdateHandler), UpdateId, UpdateData)
						:andThen(function(ClearUpdate: boolean)
							if ClearUpdate ~= false then
								player_profile.GlobalUpdates:ClearLockedUpdate(UpdateId)
							end
						end)
						:catch(warn)
						:await()
				else
					warn("[PlayerDataService]: GlobalUpdateHandler not found")
				end
			end

			for _, ActiveUpdate in pairs(player_profile.GlobalUpdates:GetActiveUpdates()) do
				OnActiveGlobalUpdate(ActiveUpdate[1], ActiveUpdate[2])
			end

			for _, LockedUpdate in pairs(player_profile.GlobalUpdates:GetLockedUpdates()) do
				task.spawn(OnLockedGlobalUpdate, LockedUpdate[1], LockedUpdate[2])
			end

			player_profile.GlobalUpdates:ListenToNewActiveUpdate(OnActiveGlobalUpdate)
			player_profile.GlobalUpdates:ListenToNewLockedUpdate(OnLockedGlobalUpdate)
		else
			player_profile:Release()
		end
	else
		player:Kick()
	end
end

local function OnPlayerLeaving(player: Player)
	local player_profile = PlayerDataService.Profiles[player]

	if player_profile ~= nil then
		player_profile:Release()
	end
end

----- Public -----

function PlayerDataService:GetProfile(player: Player | any)
	assert(t.instance("Player")(player))

	return Promise.new(function(resolve, reject)
		repeat
			if not player:IsDescendantOf(Players) then
				reject("Player left the game")
			end
			task.wait(1)
		until PlayerDataService.Profiles[player] ~= nil

		local player_profile = PlayerDataService.Profiles[player]

		if player_profile ~= nil then
			if player_profile:IsActive() then
				resolve(player_profile)
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

		local player_profile = PlayerDataService.Profiles[player]

		if player_profile ~= nil then
			if player_profile:IsActive() then
				resolve(player_profile.Data)
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
		until PlayerDataService.ProfileDataReplicas[player] ~= nil

		local player_profile_replica = PlayerDataService.ProfileDataReplicas[player]

		if player_profile_replica ~= nil then
			if player_profile_replica:IsActive() then
				resolve(player_profile_replica)
			end
		else
			reject("player_profile_replica is nil")
		end

		reject("Player left the game")
	end)
end

function PlayerDataService:AddGlobalUpdate(update_data: UpdateData)
	assert(TYPES.UpdateData(update_data))

	return Promise.new(function(resolve, reject)
		PlayerDataService.ProfileStore:GlobalUpdateProfileAsync(
			"Player_" .. tostring(update_data.ReceiverId),
			function(globalUpdates)
				globalUpdates:AddActiveUpdate(update_data)
			end
		)
		resolve()
	end)
end

----- Initialize & Connections -----

function PlayerDataService:KnitInit()
	for _, player in pairs(Players:GetPlayers()) do
		task.spawn(OnPlayerJoining, player)
	end

	-- Used to connect datastore errors to game analytics endpoints
	for _, ErrorHandler: ModuleScript in pairs(ProfileServiceErrorHandlers:GetChildren()) do
		if ErrorHandler:IsA("ModuleScript") then
			if ProfileService[ErrorHandler.Name] then
				ProfileService[ErrorHandler.Name]:Connect(require(ErrorHandler))
			end
		end
	end

	Players.PlayerAdded:Connect(OnPlayerJoining)
	Players.PlayerRemoving:Connect(OnPlayerLeaving)
end

return PlayerDataService
