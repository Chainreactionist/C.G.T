--!strict

--[[
{C.G.T}

-[CommandBarService]---------------------------------------
	Allows you to easily create admin commands using the CMDR module by Evaera
	
	Members:
	
	Functions:
	
	Members [ClassName]:
	
	Methods [ClassName]:
--]]

----- Loaded Modules -----
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.knit)
local Cmdr = require(ServerScriptService.ServerPackages.Cmdr)
local TableUtil = require(ReplicatedStorage.Packages["table-util"])

local SETTINGS = {}

----- Module Table -----

local CommandBarService = Knit.CreateService({ Name = "CommandBarService" })

----- Private Variables -----

local CommandFolderScripts: { ModuleScript } = TableUtil.Filter(
	script.Commands:GetDescendants(),
	function(instance: Instance)
		if instance:IsA("ModuleScript") then
			return true
		end
	end
)

----- Private functions -----

function InstanceNameEndsWith(instance: Instance, ending: string)
	return ending == "" or instance.Name:sub(-#ending) == ending
end

----- Public -----

----- Initialize & Connections -----

function CommandBarService:KnitInit()
	Cmdr:RegisterHooksIn(script.Hooks)

	for _, instance in pairs(CommandFolderScripts) do
		if InstanceNameEndsWith(instance, "Server") then
			local command_script = instance
			local command_description_script_name = string.gsub(instance.Name, "Server", "")
			local command_description_script = TableUtil.Find(CommandFolderScripts, function(instance: Instance)
				return instance.Name == command_description_script_name
			end)

			if not command_description_script then
				warn(command_description_script_name .. " wasn't found.")
			end

			Cmdr:RegisterCommand(command_description_script, command_script)
		end
	end
end

return CommandBarService
