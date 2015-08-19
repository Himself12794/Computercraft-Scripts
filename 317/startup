--This is a router
rednet.open('top')
term.clear()
term.setCursorPos(1,1)
print('This is computer #',os.getComputerID())

local function numbersOnly(pre,limit)-- Works like read(), except only accepts numbers. Writes a desired prefix and can accept a max number length
	term.setCursorBlink(true)
	local x,y=term.getCursorPos()
	local num=''
	while true do
		if pre then write(pre) end
		write(num)
		local event,key=os.pullEvent()
		if event=='char' and tonumber(key) then
			if #num<limit then
				num=num..key
			end
		elseif event=='key' then
			if key==14 then
				num=string.sub(num, 1, -2)
			elseif key==28 then
				print()
				term.setCursorBlink(false)
				return tonumber(num)
			end
		end
		term.setCursorPos(x,y)
		term.clearLine()
	end
end

local function checkId(id)--Checks for id in file ids, returns true if present, false if not
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

local function saveId(id)-- Saves an id to file id
	if not checkId(id) then
		local f=fs.open('ids','a')
		f.writeLine(id..'')
		f.close()
		return true
	else
		return false
	end
end

local function receiveMessage()-- Same as rednet.receive(), but returns true if sending was successful, false if not
	local id,msg,d=rednet.receive()
	rednet.send(id,true)
	return id,msg,d
end

local function sendMessage(id,msg)-- Same as rednet.send(), but sends confirmation of received message
	rednet.send(id,msg,5)
	local tid,tmsg,td=rednet.receive(5)
	if tid==id and tmsg then
		return true
	else
		return false
	end
end

local function createFile(name)--Creates a file with filename 'name'
	if not fs.exists(name) then
		f=fs.open(name,'w')
		f.writeLine('{}')
		f.close()
	end
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

local function getParentId()
	parent_id=loadFromFile('parent_id','config')
	if not parent_id then
		while true do
			local parent_id=numbersOnly('Please give the id of the parent router: ',3)
			local msg=textutils.serialize({action='registerRouter',id=os.getComputerID()})
			if sendMessage(parent_id,msg) then
				saveToFile('parent_id',parent_id,'config')
				break
			else
				print('The requested router could not be found. Please check its availability, or try another id.')
			end
			sleep(0.01)
		end
	end
	return parent_id
end

createFile('ids')
createFile('config')
local parent_id=getParentId()
print('Parent id: '..tostring(parent_id))

while true do
	local id,msg,d=receiveMessage()
	print('got message')
	local values=textutils.unserialize(msg)
	print('unserialized')
	
	if values['action']=='registerComputer' then
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
				table.insert(tmp,actions['id'])
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
		if sendMessage(parent_id,msg) then
			print('Router Id: '..tostring(parent_id)..' reception of message confirmed.')
		else
			print('Message send to Router Id: '..tostring(parent_id)..' failed.')
		end
	end
end