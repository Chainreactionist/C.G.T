--!strict

--[[
{C.G.T}

-[CorruptionSignal]---------------------------------------
	Warns of profile Corruption and Reports errors to the GameAnalyticsService module
	
	Members:
	
	Functions:
	
	Members [ClassName]:
	
	Methods [ClassName]:
	
--]]

local SETTINGS = {}

----- Loaded Modules -----

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.knit)

----- Module Table -----

local Module = {}

----- Private Variables -----

----- Private functions -----

----- Public -----

----- Initialize & Connections -----

return function(error_message, profile_store_name, profile_key)
	local profile_error = string.format(
		"[PlayerDataService]: ProfileServiceIssue %s %s %s",
		error_message,
		profile_store_name,
		profile_key
	)

	Knit.OnStart():andThen(function()
		local game_analytics_service = Knit.GetService("GameAnalyticsService")

		local user_id = string.gsub("player", "Player_", "")

		game_analytics_service:addErrorEvent(tonumber(user_id), {
			severity = game_analytics_service.EGAErrorSeverity.critical,
			message = profile_error,
		})
	end)
end
