local function receiveMessage()
	local id,msg,d=rednet.receive()
	rednet.send(id,true)
	return id,msg,d
end

local function sendMessage(id,msg)
	rednet.send(id,msg,5)
	local id,msg,d=rednet.receive(5)
	if tid==id and msg then
		return true
	else
		return false
	end
end

local function createFile()
	if not fs.exists('config') then
		f=fs.open('config','w')
		f.writeLine('{}')
		f.close()
	end
end

local function loadFromConfig(variable)
	local file=fs.open('config','r')
	local values=textutils.unserialize(file.readLine())
	for i,v in pairs(values) do
		if i==variable then
			file.close()
			return v
		end
	end
	file.close()
	return nil
end

local function saveToConfig(value,variable)
	local file=fs.open('config','r')
	local values=textutils.unserialize(file.readLine())
	values[variable]=value
	file.close()
	
	local file=fs.open('config','w')
	file.writeLine(textutils.serialize(values))
	file.close()
end
		
createFile()
saveToConfig({12,15,89},'ids')
saveToConfig(true,'apple')
