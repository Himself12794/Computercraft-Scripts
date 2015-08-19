rednet.open('top')
sender=320
function createFile()
	if not fs.exists('config') then
		f=fs.open('config','w')
		f.writeLine('false')
		f.writeLine('false')
		f.close()
	end
end

function getState(process)
	f=fs.open('config', 'r')
	local state1=f.readLine()
	local state2=f.readLine()
	f.close()
	if process=='lava' then
		return state1 == "true"
	elseif process=='day' then
		return state2 == 'true'
	else
		return nil
	end
end

function saveState(process,state)
	local s1=getState('lava')
	local s2=getState('day')
	f=fs.open('config', 'w')
	if process=='lava' then
		f.writeLine(state)
		f.writeLine(s2)
		f.close()
		return true
	elseif process=='day' then
		f.writeLine(s1)
		f.writeLine(state)
		f.close()
		return true
	else
		return false
	end
end

function printValues()
	if getState('lava') then
		eulava=18*24
	else
		eulava=0
	end
	if getState('day') then
		eusolar=512
	else
		eusolar=32
	end
	term.clear()
	term.setCursorPos(0,0)
	print('')
	print('Estimated eu/t generation is: '..tostring(128+eulava+eusolar)..' eu/t')
end

function getValues()
	printValues()
	while true do
		id,msg,d=rednet.receive()
		print(msg[1])
		if id==sender then
			msg=textutils.unserialize(msg)
			saveState('lava', msg[1])
			saveState('day', msg[2])
			printValues()
		else
			rednet.send(id,'hello friend!')
		end
		sleep(0.01)
	end
end
createFile()
getValues()