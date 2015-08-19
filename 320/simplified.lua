function receiveMessage()
	local id,msg,d=rednet.receive()
	rednet.send(id,true)
	return id,msg,d
end

function sendMessage(id,msg)
	rednet.send(id,msg,5)
	local tid,tmsg,td=rednet.receive(5)
	if tid==id and msg then
		return true
	else
		return false
	end
end

function createFile()
	if not fs.exists('config') then
		f=fs.open('config','w')
		f.writeLine('false')
		f.writeLine('false')
		f.close()
	end
end