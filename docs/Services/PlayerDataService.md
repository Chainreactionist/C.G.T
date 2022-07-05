A module to manage the loading and unloading of player data. Built With <a href="https://madstudioroblox.github.io/ProfileService/api/" target="_blank">`ProfileService`</a>

## Setting Up

1. To get started you must first edit `SETTINGS.SaveStructure` in `PlayerDataService`. Add and remove variables of `SaveStructure` as you see fit your needs. <a href="https://madstudioroblox.github.io/ProfileService/troubleshooting/" target="_blank">`Ran into an issue?, Troubleshooting`</a>
```lua
SETTINGS.SaveStructure = {
	Coins = 10,
	Streak = 1,
	Rank = "Owner",
}
```

2. It's VERY VERY important that you understand <a href="https://madstudioroblox.github.io/ProfileService/" target="_blank">`ProfileService`</a>. Read the documentation and follow the creator on <a href="https://twitter.com/LM_loleris" target="_blank">`Twitter`</a> 😎

### Testing

For testing using live profiles in a non destructive manner set 
<a href="https://madstudioroblox.github.io/ProfileService/api/#profilestoremock" target="_blank">`SETTINGS.MockProfiles`</a>
in `SETTINGS.MockProfiles` to true.

!!! warning
	GlobalUpdates do not run while profiles are being mocked. You should structure your game in a way that your testing place is separate from your main game to allow you to test without limitations.

## Basic Usage

=== "Changing Data"

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
		local player_data_service = Knit.GetService("PlayerDataService")

		local player = Players:GetPlayers()[1] or Players.PlayerAdded:Wait()

		player_data_service:GetDataReplica(player):andThen(function(DataReplica)
			DataReplica:SetValue("SomeData", DataReplica.Data.SomeData + 100)-- The value you're changing has to have been added in your save structure
		end)
	end

	return TestService
    ```

=== "Handling data changes"

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
		ReplicaController.ReplicaOfClassCreated("PlayerData", function(replica)
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

- ### <a href="https://madstudioroblox.github.io/ProfileService/api/#profilestore" target="_blank">`ProfileStore`</a>
- ### <a href="https://madstudioroblox.github.io/ProfileService/api/#profile" target="_blank">`Profiles`</a>
- ### <a href="https://madstudioroblox.github.io/ReplicaService/api/#replica" target="_blank">`ProfileDataReplicas`</a>

## Functions

### PlayerDataService:GetData(player):
<a href="https://madstudioroblox.github.io/ProfileService/api/#profiledata" target="_blank">`Promise<Profile.Data>`</a>
```lua
PlayerDataService:GetData(player):andThen(function(data)
	print(data.SomeData)
end)
```

### PlayerDataService:GetProfile(player):
<a href="https://madstudioroblox.github.io/ProfileService/api/#profile" target="_blank">`Promise<Profile>`</a>
```lua
PlayerDataService:GetProfile(player):andThen(function(profile)
	print(profile.Data.SomeData)
end)
```

### PlayerDataService:GetDataReplica(player):
<a href="https://madstudioroblox.github.io/ReplicaService/api/#replica" target="_blank">`Promise<ProfileReplica>`</a>
```lua
PlayerDataService:GetDataReplica(player):andThen(function(profile_replica)
	profile_replica:SetValue("SomeData", ProfileReplica.Data.SomeData + 100)
end)
```

### PlayerDataService:AddGlobalUpdate(UpdateData)
To set up a <a href="https://madstudioroblox.github.io/ProfileService/api/#global-updates" target="_blank">`GlobalUpdate`</a> you should:

1. First make a GlobalUpdateHandler module in the GlobalUpdateHandler Folder(Member of PlayerDataService) and give it a unique name(Name should match type when adding one).

2. Make a an UpdateData Type at the top of the script for intellisense
```lua
type UpdateData = { Id: string, SenderId: number, TimeSent: number, RecieverId: number, Data: {} }
```

3. return a function that takes ```lua UpdateId: number ``` and ```lua UpdateData: UpdateData``` as parameter to the function
```lua
return function(update_id: number, update_data: UpdateData)

end
```

1. If false is returned the update won't be cleared and this same function will run on then next time they rejoin.
```lua
return function(update_id: number, update_data: UpdateData)
	-- Do something with the data like notifying them that they were given something
	-- How you chose to handle this is completely up to you :D
	return false 
end
```

5. Lastly you just add a
<a href="https://madstudioroblox.github.io/ProfileService/api/#global-updates" target="_blank">`GlobalUpdate`</a>
using the built in AddGlobalUpdate function.

```lua
PlayerDataService:AddGlobalUpdate({
	Id = "Gift",
	SenderId = 69420,
	TimeSent = os.time(),
	ReceiverId= 69420,
	Data = {
		SomeData = 10
	} 
})
```