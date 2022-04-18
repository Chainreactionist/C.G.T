--!strict

--[[
{C.G.T}

-[GameAnalyticsService]---------------------------------------
	Responsible for initializing the game analytics module
	Links:
		https://gameanalytics.com/docs/s/topic/0TO6N000000XZEdWAO/roblox-sdk

		https://sleitnick.github.io/Knit/
		
	Members:
	
	Functions:
	
	Members [ClassName]:
	
	Methods [ClassName]:
	
--]]

local SETTINGS = {}

----- Loaded Modules -----

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.knit)
local GameAnalytics = require(ReplicatedStorage.Packages.gameanalyticssdk)

----- Module Table -----

local Module = {}

----- Private Variables -----

----- Private functions -----

----- Public -----

----- Initialize -----

function Knit:KnitInit()
	GameAnalytics:initialize({
		build = "0.1",

		gameKey = "",
		secretKey = "",

		enableInfoLog = true,
		enableVerboseLog = false,

		enableDebugLog = nil,

		automaticSendBusinessEvents = true,
		reportErrors = true,

		availableCustomDimensions01 = {},
		availableCustomDimensions02 = {},
		availableCustomDimensions03 = {},
		availableResourceCurrencies = {},
		availableResourceItemTypes = {},
		availableGamepasses = {},
	})
end
----- Connections -----

return Module
