rednet.open('top')
--This is a console

os.loadAPI('functions')
os.loadAPI('errors')

local function header()
	
	term.clear()
	term.setCursorPos(1,1)
	
	print('HimCo Industries\' Experimental OS')
	print()
	
end	

local function registerComputer()

	local msg=functions.ser({id=os.getComputerID(),action='registerComputer'})
	rednet.broadcast(msg)
	print('looking for valid router')
	local id=rednet.receive(5)
	if not id then
		print('Could not find valid router.')
		return false
	end
	local id,msg=functions.receiveMessage(5)
	if not id then
		print('No valid router found')
		return false
	end
	
	local values=functions.unser(msg)
	
	if values['action']=='computerAdded' then
	
		print('saving router id #',values['id'],' as parent router')
		functions.saveToFile('parent_id',values['id'],'config')
		return true
		
	end

end

local function checkSession()
	
	if functions.loadFromFile('offline') then
		return true
	elseif not functions.loadFromFile('session') then
		return false
	end
	
	local msg=functions.ser({action='password_server',id=os.getComputerID(),value='session',username=functions.loadFromFile('session','config')})
	functions.sendMessage(parent_id,msg)
	
	local id,msg=functions.receiveMessage(3)
	
	if errors.noService(id,'error') then
		return 'error'
	end
	
	local values=functions.unser(msg)
	
	if values['user_id']==os.getComputerID() then
		functions.saveToFile('session',values['username'])
		return true
	else
		return values['value']
	end

end

local function goOffline()
	
	print('Could not connect to server. Do you want to enter offline mode?')
	if functions.dichotomy('Go Offline','Quit') then
		functions.saveToFile('session','Guest')
		functions.saveToFile('offline',true)
	else
		os.shutdown()
	end

end

local function login()
	header()
	
	local session=checkSession()
	
	if session then
		return true
	elseif session=='error' then
		goOffline()
	end
	
	write('Please give your username: ')
	local username=read()
	print()
	
	write('Please give your password: ')
	local password=read('*')
	
	local msg=functions.ser({action='password_server',id=os.getComputerID(),value='login',password=password, username=username})
	if functions.sendMessage(parent_id,msg) then
	
		local id,msg=functions.receiveMessage(5)
		
		if errors.noService(id) then
	
			goOffline()
			
		end
			
		
		local values=functions.unser(msg)
		if values['session']~=os.getComputerID() then
		
			print('That profile is already open on computer #',values['session'],'. Please logout there, and try again.')
			sleep(2)
			os.reboot()
			
		elseif values['value'] and values['session']==os.getComputerID() then
		
			print('User ',username,' has been logged in.')
			functions.saveToFile('session',username)
			sleep(2)
			return true
			--os.reboot()
			
		else
			sleep(2)
			print('Username and password combination do not match')
			sleep(2)
			os.reboot()
			
		end	
	else
		goOffline()
	end
end

local function registerAccount()

	local password
	local username
	
	while true do
		
		header()
		write('Give a username: ')
		username=read()
		
		write('Give a password: ')
		password=read('*')
	
		write('Please confirm password: ')
		local tmp=read('*')
	
		if tmp==password then break end
		print('Passwords do not match, please try again')
		sleep(1.5)
	
	end

	local msg=functions.ser({action='password_server',id=os.getComputerID(),value='create',password=password,username=username})
	functions.sendMessage(parent_id,msg)

	local id,msg=functions.receiveMessage()

	local values=functions.unser(msg)
	
	if values['action']=='return' and values['value'] then
	
		print('Account created.')
		sleep(2)
		os.reboot()
	
	else
	
		print('Account already exists.')
		sleep(2)
		os.reboot()
		
	end
	
end
	

local function validate(parent_id)

	local choices={
		'Login',
		'Create Account',
		'Shutdown'
	}

	local choice=functions.multipleChoice(choices,1,2)
	if not choice then
		os.reboot()
	end
	
	if choice==1 then

		login()
	
	elseif choice==2 then
		
		registerAccount()
		
	elseif choice==3 then
	
		os.shutdown()
		
	end
end

functions.createFile('config')

if not functions.loadFromFile('parent_id','config') then

	registerComputer()
	
end

parent_id=functions.loadFromFile('parent_id')

--local session=checkSession()

--if not session then

header()
validate(parent_id)

--elseif session=='error' then
	
--end
shell.setDir('files')
shell.run('menu')