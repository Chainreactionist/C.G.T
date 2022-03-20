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
local Cmdr = require(ServerScriptService.ServerPackages.Cmdr)

----------------->> MODULE

local CommmandBarService = Knit.CreateService({ Name = "CommandBarService" })

----------------->> PUBLIC VARIABLES

----------------->> PUBLIC FUNCTIONS

----------------->> PRIVATE VARIABLES

----------------->> PRIVATE FUNCTIONS

----------------->> INITIALIZE & CONNECTIONS

function CommmandBarService:KnitInit()
	Cmdr:RegisterDefaultCommands()

	for i, CommandPair: Folder in pairs(ServerScriptService.Server.Commands:GetChildren()) do
		local CommandScript = CommandPair:FindFirstChild(CommandPair.Name, true)
		local CommandServerScript = CommandPair:FindFirstChild(CommandPair.Name .. "Server", true)

		Cmdr:RegisterCommand(CommandScript, CommandServerScript)
	end
end
----------------->> RETURN

return Cmdr
