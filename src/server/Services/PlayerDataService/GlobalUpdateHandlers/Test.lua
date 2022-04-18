type UpdateData = { Id: string, SenderId: number, TimeSent: number, RecieverId: number, Data: {} }

return function(UpdateId: number, UpdateData: UpdateData)
	print(UpdateId, UpdateData)

	return true -- If false is returned the update won't be cleared and this same function will run on then next time they rejoin.
end
