rednet.open('top')
print('This is the master server')

local function receiveMessage()
	local id,msg,d=rednet.receive()
	rednet.send(id,true)
	return id,msg,d
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

local function createFile(name)
	if not fs.exists(name) then
		f=fs.open(name,'w')
		f.writeLine('{}')
		f.close()
	end
end

local function loadFromFile(variable,file)
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
	print('Saving to file ',file)
	local file=file or 'config'
	createFile(file)
	local file_path=fs.open(file,'r')
	local values=textutils.unserialize(file_path.readLine())
	values[variable]=value
	file_path.close()
	
	local file_path=fs.open(file,'w')
	file_path.writeLine(textutils.serialize(values))
	file_path.close()
end

local function checkId(id)
	if fs.exists("ids") then
		local f = fs.open("ids", "r")
		for line in f.readLine do
			if line:find(id) then
				return true
			end
		end
		return false
	end
end

local function checkValidIds(id)
	local file=fs.open('server_ids','r')
	
	for _,v in pairs(file.readLine()) do
		if id==v then
			return true
		end
	end
	for _,v in ipairs(loadFromFile('router_ids')) do
		if id==v then
			return true
		end
	end
	if not checkId(id) then
		return false
	end
	return false
end

local function saveId(id)
	if not checkId(id) then
		local f=fs.open('ids','a')
		f.writeLine(id..'')
		f.close()
		return true
	else
		return false
	end
end

local function rerout(values)
	local server_id=loadFromFile(values['action'],'server_ids')
	if not server_id then
		print('requested sub-server does not exist')
		return false
	else
		print(values['id'],' to ',server_id)
		local msg=textutils.serialize(values)
		sendMessage(server_id,msg)
	end
end

local function actionHandler(msg)
	local values=textutils.unserialize(msg)
	print('unserialized')
	print('Action is ',values['action'])
	if values['action']=='register' then
		saveId(values['id'])
	elseif values['action']=='registerSubServer' then
		saveToFile(values['value'],values['id'],'server_ids')
		print('Registered Sub-Server')
	elseif values['action']=='registerComputer' then
		if not checkId(values['id']) then
			saveId(values['id'])
			print('Adding computer ID # '..tostring(values['id'])..' to the id list')
		end
		local msg=textutils.serialize({id=os.getComputerID(),action='computerAdded'})
		sendMessage(values['id'],msg)
	elseif values['action']=='registerRouter' then
		if not loadFromFile('router_ids','config') then
			saveToFile('router_ids',{values['id']},'config')
		else
			local exists=false
			for _,v in ipairs(loadFromFile('router_ids','config')) do
				if v==values['id'] then 
					exists=true
				end
			end
			if not exists then
				local tmp=loadFromFile('router_ids','config')
				table.insert(tmp,values['id'])
				saveToFile('router_ids',tmp,'config')
			end
		end
	elseif values['action']=='return' then
		if checkId(values['id']) then
			sendMessage(values['id'],msg)
		else
			for _,v in ipairs(loadFromFile('router_ids','config')) do
				sendMessage(v,msg)
			end
		end
	else
		print('rerouting')
		rerout(values)
	end
end

createFile('server_ids')
createFile('ids')
print('This computer\'s ID is: '..tostring(os.getComputerID()))

while true do
	local id,msg=receiveMessage()
	print('Got a message from ',id)
	actionHandler(msg)
end
