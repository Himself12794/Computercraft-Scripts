args={...}
rednet.open('top')
idbattery=309
idmove=313
idplace=314

function createConfig()
	if not fs.exists('config') then
		f=fs.open('config','w')
		local temp={}
		temp[1]=false
		temp[2]=false
		temp[3]=false
		f.writeLine(textutils.serialize(temp))
		f.close()
	end
end

function setState(process, state)
	f=fs.open('config','r')
	local temp=textutils.unserialize(f.readLine())
	f.close()
	f=fs.open('config','w')
	if process=='battery' then
		if state then
			temp[1]='true'
		else
			temp[1]='false'
		end
	elseif process=='move' then
		if state then
			temp[2]='true'
		else
			temp[2]='false'
		end
	elseif process=='place' then
		if state then
			temp[3]='true'
		else
			temp[3]='false'
		end
	end
	f.writeLine(textutils.serialize(temp))
	f.close()
end

function getState(process)
	f=fs.open('config','r')
	local values=textutils.unserialize(f.readLine())
	if process=='battery' then
		f.close()
		return values[1]
	elseif process=='move' then
		f.close()
		return values[2]
	elseif process=='place' then
		f.close()
		return values[3]
	else
		f.close()
		return values
	end
end

function printState()
	term.clear()
	term.setCursorPos(0,0)
	print('')
	print('Boreing 2.0')
	local temp=getState()
	print('Batteries active: '..temp[1])
	print('Digging active: '..temp[2])
	print('Block placing active: '..temp[3])
end

function action()
	while true do
		id, msg = rednet.receive()
		msg=textutils.unserialize(msg)
		if msg[1]=='battery' then
			if msg[2]=='true' then
				setState('battery',true)
				printState()
				rednet.send(idbattery,getState('battery'),true)
				rednet.send(id,getState('battery'),true)
			else
				setState('battery',false)
				printState()
				rednet.send(idbattery,getState('battery'),true)
				rednet.send(id,getState('battery'),true)
			end					
		elseif msg[1]=='move' then
			if msg[2]=='true' then
				setState('move',true)
				printState()
				rednet.send(idmove,getState('move'),true)
				rednet.send(id,getState('move'),true)
			else
				setState('move',false)
				printState()
				rednet.send(idmove,getState('move'),true)
				rednet.send(id,getState('move'),true)
			end		
		elseif msg[1]=='place' then
			if msg[2]=='true' then
				setState('place',true)
				printState()
				rednet.send(idplace,getState('place'),true)
				rednet.send(id,getState('place'),true)
			else
				setState('place',false)
				printState()
				rednet.send(idplace,getState('place'),true)
				rednet.send(id,getState('place'),true)
			end			
		end
		sleep(0.01)
	end
end

createConfig()
printState()
action()