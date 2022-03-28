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
local TableUtil = require(ReplicatedStorage.Packages["table-util"])

----------------->> MODULE

local CommmandBarService = Knit.CreateService({ Name = "CommandBarService" })

----------------->> PRIVATE VARIABLES
----------------->> PRIVATE FUNCTIONS
----------------->> PUBLIC VARIABLES
----------------->> PUBLIC FUNCTIONS

function EndsWith(instance: Instance, ending: string)
	return ending == "" or instance.Name:sub(-#ending) == ending
end

----------------->> INITIALIZE & CONNECTIONS

function CommmandBarService:KnitInit()
	Cmdr:RegisterDefaultCommands()

	local CommandPairs = {}
	local CommandFolder = ServerScriptService.Server.Commands
	local CommandFolderDesendants = CommandFolder:GetDescendants()
	local CommandFolderScripts = TableUtil.Filter(CommandFolderDesendants, function(instance: Instance)
		if instance:IsA("ModuleScript") then
			return true
		end
	end)

	for _, instance in pairs(CommandFolderScripts) do
		local CommandScript
		local CommandScriptDescription

		if EndsWith(instance, "Server") then
			CommandScript = instance
			local CommandScriptDescriptionName = string.gsub(instance.Name, "Server", "")
			CommandScriptDescription = TableUtil.Find(CommandFolderScripts, function(instance: Instance)
				return instance.Name == CommandScriptDescriptionName
			end)

			if not CommandScriptDescription then
				warn(CommandScriptDescription.Name .. " wasn't found.")
				break
			end

			table.insert(CommandPairs, { CommandScriptDescription, CommandScript })
		end
	end

	for _, CommandPair in pairs(CommandPairs) do
		Cmdr:RegisterCommand(CommandPair[1], CommandPair[2])
	end
end

----------------->> RETURN

return Cmdr
