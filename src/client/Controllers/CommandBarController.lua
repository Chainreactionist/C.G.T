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

local ReplicatedStorage = game:GetService("ReplicatedStorage")

----------------->> LOADED MODULES

local Knit = require(ReplicatedStorage.Packages.knit)
local Cmdr = require(ReplicatedStorage:WaitForChild("CmdrClient"))

----------------->> MODULE

local CommandBarController = Knit.CreateController({
	Name = "CommandBarController",
	Client = {},
})

----------------->> PUBLIC VARIABLES

----------------->> PUBLIC FUNCTIONS

----------------->> PRIVATE VARIABLES

----------------->> PRIVATE FUNCTIONS

----------------->> INITIALIZE & CONNECTIONS

function CommandBarController:KnitInit()
	Cmdr:SetActivationKeys({ Enum.KeyCode.BackSlash })
end

----------------->> RETURN
return CommandBarController
