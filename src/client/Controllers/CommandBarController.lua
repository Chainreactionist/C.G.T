--!strict

--[[
{C.G.T}

-[CommandBarController]---------------------------------------
	Allows you to easily manage essential tools required to run admin commands(Keybinds, e.t.c)
	
	Members:
	
	Functions:
	
	Members [ClassName]:
	
	Methods [ClassName]:
--]]

SETTINGS = {}

----- Loaded Modules -----

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.knit)
local Cmdr = require(ReplicatedStorage:WaitForChild("CmdrClient"))

----- Module Table -----

local CommandBarController = Knit.CreateController({
	Name = "CommandBarController",
	Client = {},
})

----- Private Variables -----

----- Private functions -----

----- Public -----

----- Initialize & Connections -----

function CommandBarController:KnitInit()
	Cmdr:SetActivationKeys({ Enum.KeyCode.RightBracket })
end

return CommandBarController
