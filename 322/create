rednet.open('top')
print('This is the master server')

local function receiveMessage()
	local id,msg,d=rednet.receive()
	rednet.send(id,true)
	return id,msg,d
end

local function loadFromFile(variable,file)
	local file=file or 'config'
	local file_path=fs.open(file,'r')
	local values=textutils.unserialize(file_path.readLine())
	for i,v in pairs(values) do
		if i==variable then
			file_path.close()
			return v
		end
	end
	file_path.close()
	return nil
end

local function saveToFile(variable,value,file)
	local file=file or 'config'
	createFile(file)
	local file_path=fs.open(file,'r')
	local values=textutils.unserialize(file_path.readLine())
	values[variable]=value
	file_path.close()
	
	local file_path=fs.open('config','w')
	file_path.writeLine(textutils.serialize(values))
	file_path.close()
end

local function sendMessage(id,msg)
	rednet.send(id,msg,5)
	local tid,tmsg,td=rednet.receive(5)
	if tid==id and msg then
		return true
	else
		return false
	end
end

local parent_id=loadFromFile('parent_id')
local msg=textutils.serialize({action='password_server',id=os.getComputerID(),value='create',password='password',username='username'})
sendMessage(parent_id,msg)