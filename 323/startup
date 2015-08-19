os.loadAPI('functions')
rednet.open('top')
shell.run('clear')
local function header() -- Prints the header
	functions.lineClear()
	functions.printCentered('This is the password server')
	functions.lineClear()
	print()
	functions.lineClear()
	print('Computer:  #',os.getComputerID())
	functions.lineClear()
	print('Parent Computer:  #',parent_id)
	functions.lineClear()
	print('===================================================')
	functions.lineClear()
	print()
end

local function getParentId() -- Attempts to retrieve parent router id from memory. If not found, requests the id.
	parent_id=functions.loadFromFile('parent_id','config')
	if not parent_id then
		while true do
			local parent_id=functions.numbersOnly('Please give the id of the parent router: ',3)
			local msg=functions.ser({action='registerSubServer',id=os,.getComputerID(),value='password_server'})
			if functions.sendMessage(parent_id,msg) then
				functions.saveToFile('parent_id',parent_id,'config')
				break
			else
				print('The requested router could not be found. Please check its availability, or try another id.')
			end
			sleep(0.01)
		end
	end
	return parent_id
end

local function manager(msg) -- Manages actions based on message requests
	local values=functions.unser(msg)
	functions.lineClear()
	print('Received message from Computer #',values['id'])
	functions.lineClear()
	print('Value is ',values['value'])
	local verify=false
	-------------------------------------
	if values['value']=='create' then
	--[----------------------------------
		if not functions.loadFromFile(values['username'],'passwords') then
			functions.saveToFile(values['username'],values['password'],'passwords')
			functions.lineClear()
			print('Created account for ',values['username'])
			verify=true
		end 
		
		local msg=functions.ser({action='return',id=values['id'],value=verify})
		functions.sendMessage(parent_id,msg)
	-------------------------------------]	
	elseif values['value']=='login' then
	--[-----------------------------------
		if not functions.loadFromFile(values['username'],'sessions') then
			if functions.loadFromFile(values['username'],'passwords')==values['password'] then
				functions.lineClear()
				print('Logging in ',values['username'])
				functions.saveToFile(values['username'],values['id'],'sessions')
				verify=true
			end
		elseif values['id']==functions.loadFromFile(values['username'],'sessions') then
			verify=true
		end
		local msg=functions.ser({action='return',id=values['id'],value=verify,session=functions.loadFromFile(values['username'],'sessions')})
		functions.sendMessage(parent_id,msg)
	-------------------------------------]
	elseif values['value']=='session' then
	--[-----------------------------------
		user_id=functions.loadFromFile(values['username'],'sessions')
		verify=user_id==values['id']
		local msg=functions.ser({action='return',id=values['id'],value=verify,session_id=user_id,username=values['username']})
		functions.sendMessage(parent_id,msg)
		functions.lineClear()
		print('Send Message to ',values['id'])
	--------------------------------------]
	elseif values['value']=='logout' then
	--[------------------------------------
		if functions.loadFromFile(values['username'],'sessions')==values['id'] then
			functions.lineClear()
			print('Logging out ',values['username'])
			functions.saveToFile(values['username'],nil,'sessions')
			verify=true
		end
		
		local msg=functions.ser({action='return',id=values['id'],value=verify})
		functions.sendMessage(parent_id,msg)
	end
end

functions.createFile('config')
functions.createFile('passwords')
functions.createFile('sessions')
functions.saveToFile('Guest',false,'sessions')
parent_id=getParentId()
header()

while true do
	local id,msg=functions.receiveMessage()
	manager(msg)
	local x,y=term.getCursorPos()
	term.setCursorPos(1,1)
	header()
	term.setCursorPos(x,y)
end
