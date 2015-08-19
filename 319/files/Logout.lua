parent_id=functions.loadFromFile('parent_id')

function endSession()
	local username=functions.loadFromFile('session')

	local msg=functions.ser({action='password_server',id=os.getComputerID(),value='logout',username=username})
	
	functions.sendMessage(parent_id,msg)
	local id,msg=functions.receiveMessage(5)
	functions.saveToFile('session',false)
	
	if not id then
		header('You must be logged in to log out.')
		sleep(2)
		header('You can only log out of client session.')
		sleep(2)
	end
end
	
	

shell.run('cd','/')
if not functions.loadFromFile('offline') then
	
	endSession()

else

	functions.saveToFile('offline',false)
	functions.saveToFile('session',false)
	
end
os.reboot()
