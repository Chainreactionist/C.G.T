--!strict

--[[
{C.G.T}

-[Module]---------------------------------------
	Module description
	
	Members:
	
	Functions:
	
	Members [ClassName]:
	
	Methods [ClassName]:
	
--]]

----- Loaded Modules -----
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.knit)

local SETTINGS = {}

----- Module Table -----

local Module = Knit.CreateController({ Name = "Module" })

----- Private Variables -----

----- Private functions -----

----- Public -----

function Module:KnitInit() end

function Module:KnitStart() end

----- Initialize & Connections -----

return Module
