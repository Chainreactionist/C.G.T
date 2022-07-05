A module to initialize and register a keybind to open Cmdr <a href="https://eryn.io/Cmdr/" target="_blank">`Cmdr`</a>

Edit the key bind to suit your preference 

```lua hl_lines="42 43 44"
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
	Cmdr:SetActivationKeys({ Enum.KeyCode.BackSlash })
end

return CommandBarController

```