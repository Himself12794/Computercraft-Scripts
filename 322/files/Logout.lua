parent_id=functions.loadFromFile('parent_id')
shell.run('cd','/')

function endSession()
	local username=functions.loadFromFile('session')
	print('username')
	sleep(2)

	local msg=functions.ser({action='password_server',id=os.getComputerID(),value='logout',username=username})
	
	functions.sendMessage(parent_id,msg)
	local id,msg=functions.receiveMessage(5)
	functions.saveToFile('session',false)
	
	if not id then
		functions.header('You must be logged in to log out.')
		sleep(2)
		functions.header('You can only log out of client session.')
		sleep(2)
	end
end

if functions.loadFromFile('session')=='Guest' then
	
	endSession()

else

	functions.saveToFile('offline',false)
	functions.saveToFile('session',false)
	
end
os.reboot()
