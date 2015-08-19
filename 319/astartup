rednet.open('top')

function receiveMessage()
	local id,msg,d=rednet.receive()
	rednet.send(id,true)
	return id,msg,d
end

function receiveRouted()
	while true do
		id,msg,d=receiveMessage()
		if msg~='find router' then
			print(msg)
		end
		sleep(0.01)
	end
end
	
id,msg,d=receiveMessage()
print(msg)