--!strict

--[[
{C.G.T}

-[Client]---------------------------------------
	Responsible for initializing every server sided module(Services) and Components(classes) that auto apply to objects
	
	Members:
	
	Functions:
	
	Members [ClassName]:
	
	Methods [ClassName]:
--]]

local SETTINGS = {}

----- Loaded Modules -----

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.knit)

----- Module Table -----

local Module = {}

----- Private Variables -----

local ServicesFolder = ServerScriptService.Server.Services
local StartTime = tick()

----- Private functions -----

local function RoundDecimalPlaces(num, decimalPlaces)
	local mult = 10 ^ (decimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

local function OnStartSuccess()
	warn(string.format("Server Started (%s)", RoundDecimalPlaces(tostring(tick() - StartTime), 5)))
end

local function OnStartFailure(error)
	warn(string.format("Server Errored (%s)", RoundDecimalPlaces(tostring(tick() - StartTime), 5)))
	warn(error)
end

----- Public -----

----- Initialize & Connections -----

Knit.AddServices(ServicesFolder)

Knit.Start():andThen(OnStartSuccess):catch(OnStartFailure):await()

return Module
