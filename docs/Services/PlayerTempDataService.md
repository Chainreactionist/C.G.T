A module to manage the loading and unloading of player data. Built With <a href="https://madstudioroblox.github.io/ProfileService/api/" target="_blank">`ProfileService`</a>

## Setting Up

1. To get started you must first edit `SETTINGS.SaveStructure` in `PlayerTempDataService`. Add and remove variables of `SaveStructure` as you see fit your needs. <a href="https://madstudioroblox.github.io/ProfileService/troubleshooting/" target="_blank">`Ran into an issue?, Troubleshooting`</a>
```lua
SETTINGS.SaveStructure = {
	SomeRandomTempValue = 10
}
```

## Basic Usage

=== "Changing TempData"

    ``` lua
	--!strict

	--[[
	{C.G.T}

	-[TestService]---------------------------------------
		A module for testing other modules
		
		Members:
		
		Functions:
		
		Members [ClassName]:
		
		Methods [ClassName]:
		
	--]]

	local SETTINGS = {}

	----- Loaded Modules -----

	local Players = game:GetService("Players")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local Knit = require(ReplicatedStorage.Packages.knit)

	----- Module Table -----

	local TestService = Knit.CreateService({ Name = "TemplateService" })

	----- Private Variables -----

	----- Private functions -----

	----- Public -----

	----- Initialize & Connections -----

	function TestService:KnitStart()
		local player_temp_data_service = Knit.GetService("PlayerDataService")

		local player = Players:GetPlayers()[1] or Players.PlayerAdded:Wait()

		player_temp_data_service:GetDataReplica(player):andThen(function(DataReplica)
			DataReplica:SetValue("SomeData", DataReplica.Data.SomeData + 100)-- The value you're changing has to have been added in your save structure
		end)
	end

	return TestService
    ```

=== "Handling TempData Changes"

	``` lua
	--!strict

	--[[
	{C.G.T}

	-[TestController]---------------------------------------
		A module for testing other modules
		
		Members:
		
		Functions:
		
		Members [ClassName]:
		
		Methods [ClassName]:
		
	--]]

	local SETTINGS = {}

	----- Loaded Modules -----

	local Players = game:GetService("Players")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local Knit = require(ReplicatedStorage.Packages.knit)
	local ReplicaController = require(game.ReplicatedStorage.Packages.replicaservice)

	----- Module Table -----

	local TestController = Knit.CreateController({ Name = "TestController" })

	----- Private Variables -----

	----- Private functions -----

	----- Public -----

	----- Initialize & Connections -----

	function TestController:KnitStart()
		ReplicaController.ReplicaOfClassCreated("PlayerTempData", function(replica)
			if replica.Tags.Player == Players.LocalPlayer then
				replica:ListenToChange("SomeData", function()
					print("SomeData Changed")
					--Do Something when SomeData changes
				end)
			end
		end)
	end

	return TestController

	```


## Members

 - ### <a>`Datas`</a>(Yes I am aware that data is a plural)
 - ### <a href="https://madstudioroblox.github.io/ReplicaService/api/#replica" target="_blank">`DataReplicas`</a>


## Functions

### PlayerTempDataService:GetData(player):
<a href="https://madstudioroblox.github.io/ProfileService/api/#profiledata" target="_blank">`Promise<TempData>`</a>
```lua
PlayerDataService:GetData(player):andThen(function(data)
	print(data.SomeTempData)
end)
```
### PlayerDataService:GetDataReplica(player):
<a href="https://madstudioroblox.github.io/ReplicaService/api/#replica" target="_blank">`Promise<TempDataReplica>`</a>
```lua
PlayerDataService:GetDataReplica(player):andThen(function(profile_replica)
	profile_replica:SetValue("SomeTempData", ProfileReplica.Data.SomeTempData + 100)
end)
```