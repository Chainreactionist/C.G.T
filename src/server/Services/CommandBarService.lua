--!strict

--[[
	DESCRIPTION:
--]]

--[[
	MEMBERS:

	FUNCTIONS:

	MEMBERS [ClassName]:

	METHODS [ClassName]:

	LINKS:
]]

----------------->> SETTINGS

----------------->> SERVICES

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

----------------->> LOADED MODULES

local Knit = require(ReplicatedStorage.Packages.knit)
local Cmdr = require(ReplicatedStorage.ServerPackages.Cmdr)

----------------->> MODULE

local CommmandBarService = Knit.CreateService({ Name = "CommandBarService" })

----------------->> PUBLIC VARIABLES

----------------->> PUBLIC FUNCTIONS

----------------->> PRIVATE VARIABLES

----------------->> PRIVATE FUNCTIONS

----------------->> INITIALIZE & CONNECTIONS

function CommmandBarService:KnitInit()
	Cmdr:RegisterDefaultCommands()
end
----------------->> RETURN

return Cmdr
