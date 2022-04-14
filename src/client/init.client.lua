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

local Settings = {}

----- Loaded Modules -----

local StarterPlayerScripts = script.Parent
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.knit)

----- Module Table -----

local Module = {}

----- Private Variables -----

local KnitStartTime = tick()
local ServicesFolder = StarterPlayerScripts.Client.Controllers

----- Private functions -----

local function RoundDecimalPlaces(num, decimalPlaces)
	local mult = 10 ^ (decimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

----- Public -----

----- Initialize & Connections -----

Knit.AddControllers(ServicesFolder)

Knit.Start()
	:andThen(function()
		warn(string.format("Client Started (%s)", RoundDecimalPlaces(tostring(tick() - KnitStartTime), 5)))
	end)
	:catch(warn)

return Module
