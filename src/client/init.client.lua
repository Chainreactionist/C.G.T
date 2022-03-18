--!strict

--[[
	NAME: Chainreactionist[784730716] & SomeOtherGuy101[000000000]
	DATE CREATED: Tuesday, March 15, 2022
	DESCRIPTION: A game template
--]]

--[[
	Members:

	Functions:

	Members [ClassName]:

	Methods [ClassName]:
]]

----------------->> SETTINGS

local Settings = {}

----------------->> SERVICES

local StarterPlayerScripts = script.Parent
local ReplicatedStorage = game:GetService("ReplicatedStorage")

----------------->> LOADED MODULES

local Knit = require(ReplicatedStorage.Packages.knit)

----------------->> MODULE

local Module = {}

----------------->> PRIVATE VARIABLES

local ServicesFolder = StarterPlayerScripts.Client.Controllers

----------------->> PRIVATE FUNCTIONS

local function RoundDecimalPlaces(num, decimalPlaces)
	local mult = 10 ^ (decimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

----------------->> PUBLIC VARIABLES
----------------->> PUBLIC FUNCTIONS
----------------->> INITIALIZE & START

Knit.AddControllers(ServicesFolder)

local KnitStartTime = tick()
Knit.Start()
	:andThen(function()
		warn(string.format("Client Started (%s)", RoundDecimalPlaces(tostring(tick() - KnitStartTime), 5)))
	end)
	:catch(warn)

----------------->> CONNECTIONS
----------------->> RETURN

return Module
