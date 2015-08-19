rednet.open('top')
main=311
side='front'

function printState()
	term.clear()
	term.setCursorPos(0,0)
	print('')
	print('Boreing 2.0')
	local temp=getState()
	if temp then
		print('Deploying: active')
	else
		print('Deploying: inactive')
	end
end

function createFile()
	if not fs.exists('config') then
		f=fs.open('config','w')
		f.writeLine('false')
		f.close()
	end
end

function getState()
	f=fs.open('config', 'r')
	local state=f.readLine()
	f.close()
	return state == "true"
end

function saveState(state)
	f=fs.open('config', 'w')
	f.writeLine(state)
	f.close()
end

function setOutput(side)
	local temp=getState()
	print(temp)
	if temp then
			rs.setOutput(side, false)
			printState()
			--print('on')
	elseif not temp then
			rs.setOutput(side, true)
			--print('off')
			printState()
	end
end

function command()
	while true do
		local temp=getState()
		setOutput(side)
		a, id, msg, dist=os.pullEvent('rednet_message')
		if id==main and msg=='true' then
			--write(id..' says ')
			--print(msg)
			saveState(true)
			rednet.send(main, getState(), true)
		elseif id==main and msg=='false' then
			saveState(false)
			rednet.send(main, getState(), true)
		end
	end
end
--print(getState())
--printState()
createFile()
command()
