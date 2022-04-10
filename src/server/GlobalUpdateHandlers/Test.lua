type UpdateData = { Id: string, SenderId: number, TimeSent: number, RecieverId: number, Data: {} }

return function(UpdateId: number, UpdateData: UpdateData)
	print(UpdateId, UpdateData)
end
