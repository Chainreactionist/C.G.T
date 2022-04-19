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
local GameAnalytics = require(ReplicatedStorage.Packages.GameAnalytics)
local Promise = require(ReplicatedStorage.Packages.promise)

----- Module Table -----

local GameAnalyticsService = Knit.CreateService({ Name = "GameAnalyticsService" })

----- Private Variables -----

----- Private functions -----

----- Public -----

----- Initialize -----

function GameAnalyticsService:KnitInit()
	--  access for access members of ProfileStore and ProfileService directly through PlayerDataService and Returns Promises as opposed to functions --
	setmetatable(GameAnalyticsService, {
		__index = function(_, index)
			if GameAnalytics[index] ~= nil then
				if type(GameAnalytics[index]) == "function" then
					return Promise.promisify(GameAnalytics[index])
				end
				return GameAnalytics[index]
			end
		end,
	})

	GameAnalytics:initialize({
		build = "0.1",

		gameKey = "8a33c1330c56b28efac7592f3187d34b",
		secretKey = "85fd4a1cae70eafe2dde015751652c704c52e5fd",

		enableInfoLog = false,
		enableVerboseLog = false,

		enableDebugLog = false,

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

return GameAnalyticsService
