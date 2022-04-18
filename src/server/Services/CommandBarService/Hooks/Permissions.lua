--!strict

--[[
{C.G.T}

-[Permissions]---------------------------------------
	A module made to determine if a player has the permissions run a commands .
	
	Members:
	
	Functions:
	
	Members [ClassName]:
	
	Methods [ClassName]:
	
--]]

local SETTINGS = {}

----- Loaded Modules -----

local Players = game:GetService("Players")

----- Module Table -----

local Permissions

----- Private Variables -----

local Groups = {
	Owners = { 784730716 },
	Admins = {},
	Moderators = {},
	--You can also use functions as a member check 💯
	-- AccountIsOverADayOld = function(user_id)
	-- 	local player = Players:GetPlayerByUserId(user_id)

	-- 	if player then
	-- 		if player.AccountAge > 1 then
	-- 			return true
	-- 		end
	-- 	end

	-- 	return false
	-- end,
}

----- Private functions -----

----- Public -----

Permissions = function(registry)
	registry:RegisterHook("BeforeRun", function(context)
		if table.find(Groups.Owners, context.Executor.UserId) then
			return
		end

		for group_name: string, member_check: { number } | () -> boolean | nil in pairs(Groups) do
			if type(member_check) == "table" then
				if string.find(group_name, context.Group) then
					if table.find(member_check, context.Executor.UserId) then
						return
					end
				end
			elseif type(member_check) == "function" then
				local success, response = pcall(member_check, context.Executor.UserId)

				if success == true and response == true then
					return
				end
			end
		end

		return "You do not meet the requirements to run this command"
	end)
end

----- Initialize & Connections -----

return Permissions
