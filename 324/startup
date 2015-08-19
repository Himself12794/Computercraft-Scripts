--File server
rednet.open('top')
print('This is computer #',os.getComputerID())
print('This is the files server')

local function unser(msg)

	local msg=textutils.unserialize(msg)
	return msg
	
end

local function ser(msg)

	local msg=textutils.serialize(msg)
	return msg
	
end

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

local function checkId(id)--Checks for id in file id, returns true if present, false if not
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
	if not fs.exists(file) then
		return nil
	end
	print('loading from file ',file)
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
			local msg=textutils.serialize({action='registerSubServer',id=os.getComputerID(),value='file_server'})
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

local function manager(msg)

	local values=unser(msg)
	if not values['value'] then
		print('not a valid message')
		return nil
	end
	if values['value']=='list' then
		
		local list=fs.list('files')
		values['action']='return'
		values['value']=list
		
		local msg=ser(values)
		sendMessage(parent_id,msg)
		print('Sent file list to ',values['id'])
		
	elseif values['value']=='delete' then
		local verify=false
		if not values['value2'] then
			print('Could not load file')
			return false
		end
		local owner=loadFromFile('owner','files/'..values['value2'])
		print('owner for ',values['value2'],' is ',owner)
		if not owner then
			print('no owner is listed for this file')
		elseif values['username']==owner then
			fs.delete('files/'..values['value2'])
			print('Deleted file \''..values['value2']..'\'')
			verify=true
		end
		print(values['id'],' ',verify)
		local msg=ser({action='return',id=values['id'],value=verify})
		sendMessage(parent_id,msg)
				
	elseif values['value']=='send' then
		
		local values=unser(msg)
		local name=values['value2']
		local content=values['value3']
		
		if fs.exists('files/'..name) then
			
			--local file_path=fs.open('files/'..name..'_new','w')
			--file_path.write(unser(content))
			print(name,' already exists')
			
			values['value']=false
			values['action']='return'
			local msg=ser(values)
			sendMessage(values['id'],msg)
			
		else
			
			saveToFile('owner',values['username'],'files/'..name)
			local file_path=fs.open('files/'..name,'a')
			--file_path.writeLine('{owner='..values['username']..'}')
			file_path.write(unser(content))
			file_path.close()
			print('Created file ',values['value2'],' by ',values['username'])
			
			values['value']=true
			values['action']='return'
			local msg=ser(values)
			sendMessage(values['id'],msg)
			
		end
		
	elseif values['value']=='get' then
	
		local file_path=fs.open('files/'..values['value2'],'r')
		local owner=file_path.readLine()
		local info=ser(file_path.readAll())
		values['action']='return'
		values['value2']=info
		
		local msg=ser(values)
		sendMessage(parent_id,msg)
		print('Sent file to ',values['id'])
		
	end
	
end

createFile('config')
parent_id=getParentId()

while true do

	local id,msg=receiveMessage()
	print('Got message')
	if id==parent_id then
		manager(msg)
	end
	
end	