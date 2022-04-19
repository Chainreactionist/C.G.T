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

1. It's VERY VERY important that you understand <a href="https://madstudioroblox.github.io/ProfileService/" target="_blank">`ProfileService`</a>. Be sure to read the documentation 😎
## Basic Usage
```lua
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

	player_data_service.ProfileStore:GetProfileReplica(player):andThen(function(ProfileReplica)
		ProfileReplica:SetValue("SomeData", ProfileReplica.Data.SomeData + 100)
	end)
end

return TestService
```

## Members

- ### <a href="https://madstudioroblox.github.io/ProfileService/api/#profilestore" target="_blank">`ProfileStore`</a>
- ### <a href="https://madstudioroblox.github.io/ProfileService/api/#profile" target="_blank">`Profiles`</a>
- ### <a href="https://madstudioroblox.github.io/ReplicaService/api/#replica" target="_blank">`ProfileDataReplicas`</a>

## Functions

### PlayerDataService:GetData(player): <a href="https://madstudioroblox.github.io/ProfileService/api/#profiledata" target="_blank">`Profile.Data`</a>
```lua
PlayerDataService:GetData(player):andThen(function(Data)
	print(Data.SomeData)
end)
```

### PlayerDataService:GetProfile(player): <a href="https://madstudioroblox.github.io/ProfileService/api/#profile" target="_blank">`Profile`</a>
```lua
PlayerDataService:GetProfile(player):andThen(function(Profile)
	print(Profile.Data.SomeData)
end)
```

### PlayerDataService:GetProfileReplica(player): <a href="https://madstudioroblox.github.io/ReplicaService/api/#replica" target="_blank">`ProfileReplica`</a>
```lua
PlayerDataService:GetProfileReplica(player):andThen(function(ProfileReplica)
	ProfileReplica:SetValue("SomeData", ProfileReplica.Data.SomeData + 100)
end)
```

### PlayerDataService:AddGlobalUpdate(UpdateData)
To set up a <a href="https://madstudioroblox.github.io/ProfileService/api/#global-updates" target="_blank">`GlobalUpdate`</a> you should:

1. First make a GlobalUpdateHandler module in the GlobalUpdateHandler Folder(Member of PlayerDataService)
2. Make a an UpdateData Type at the top of the script
```lua
type UpdateData = { Id: string, SenderId: number, TimeSent: number, RecieverId: number, Data: {} }
```
3. return a function that takes ```lua UpdateId: number ``` and ```lua UpdateData: UpdateData``` as parameter to the function
```lua
return function(UpdateId: number, UpdateData: UpdateData)
	print(UpdateId, UpdateData)
end
```
4. If false is returned the update won't be cleared and this same function will run on then next time they rejoin.
```lua
return function(UpdateId: number, UpdateData: UpdateData)
	return true 
end

```
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