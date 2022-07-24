--!strict

--[[
{C.G.T}

-[Client]---------------------------------------
	Responsible for initializing every client sided module(Services) and Components(classes) that auto apply to objects
	
	Members:
	
	Functions:
	
	Members [ClassName]:
	
	Methods [ClassName]:
--]]

local Settings = {}

----- Loaded Modules -----

local StarterPlayerScripts = script.Parent
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.knit)
local ReplicaController = require(game.ReplicatedStorage.Packages.replicaservice)

----- Module Table -----

local Module = {}

----- Private Variables -----

local StartTime = tick()
local ServicesFolder = StarterPlayerScripts.Client.Controllers

----- Private functions -----

local function RoundDecimalPlaces(num: number, decimalPlaces: number)
	local mult = 10 ^ (decimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

local function OnStartSuccess()
	warn(string.format("Client Started (%s)", tostring(RoundDecimalPlaces(tick() - StartTime, 3))))

	ReplicaController.RequestData()
end

local function OnStartFailure(error)
	warn(string.format("Client Errored (%s)", tostring(RoundDecimalPlaces(tick() - StartTime, 3))))
	warn(error)
end

----- Public -----

----- Initialize & Connections -----

Knit.AddControllers(ServicesFolder)

Knit.Start():andThen(OnStartSuccess):catch(OnStartFailure)

return Module
