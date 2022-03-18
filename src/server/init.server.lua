--!strict

--[[
	DESCRIPTION: Responsible for initializing every server sided module(Services) and classes that auto apply to objects(Components)
--]]

--[[
	MEMBERS:

	FUNCTIONS:

	MEMBERS [ClassName]:

	METHODS [ClassName]:
]]

----------------->> SETTINGS
----------------->> SERVICES

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

----------------->> LOADED MODULES

local Knit = require(ReplicatedStorage.Packages.knit)

----------------->> MODULE
----------------->> PRIVATE VARIABLES

local ServicesFolder = ServerScriptService.Server.Services
local KnitStartTime = tick()

----------------->> PRIVATE FUNCTIONS

local function RoundDecimalPlaces(num, decimalPlaces)
	local mult = 10 ^ (decimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

local function OnServerStartSuccess()
	warn(string.format("Server Started (%s)", RoundDecimalPlaces(tostring(tick() - KnitStartTime), 5)))
end

local function OnServerStartFailure(error)
	warn(string.format("Server Errored (%s)", RoundDecimalPlaces(tostring(tick() - KnitStartTime), 5)))
	warn(error)
end

----------------->> PUBLIC VARIABLES
----------------->> PUBLIC FUNCTIONS
----------------->> INITIALIZE & START

Knit.AddServices(ServicesFolder)

Knit.Start():andThen(OnServerStartSuccess):catch(OnServerStartFailure):await()

----------------->> CONNECTIONS
----------------->> RETURN
