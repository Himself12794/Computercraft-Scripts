os.loadAPI('/functions')
function noRouter(id)
	if not id then
		print('No valid router found')
		sleep(2)
	end
end

function noService(id)
	local action = false
	if not id then
		print('Could not connect to server. Please try again later.')
		sleep(2)
		action = true
	end
	return action
end

function offline()
	if functions.loadFromFile('offline') then
	
		print('You must be online to do that.')
		sleep(2)
		return true
		
	else
		
		return false
		
	end
end
