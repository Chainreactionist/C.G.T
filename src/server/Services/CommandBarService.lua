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

	for i, cmd: Folder in pairs(ReplicatedStorage.Shared.Commands:GetChildren()) do
		local commandScript = cmd:FindFirstChild(cmd.Name, true)
		local commandServerScript = cmd:FindFirstChild(cmd.Name .. "Server", true)

		Cmdr:RegisterCommand(commandScript, commandServerScript)
	end
end
----------------->> RETURN

return Cmdr
