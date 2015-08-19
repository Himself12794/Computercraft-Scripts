function debugger(shellObj,file)
	shellObj.run(file)
end

function unser(msg)

	local msg=textutils.unserialize(msg)
	return msg
	
end

function ser(msg)

	local msg=textutils.serialize(msg)
	return msg
	
end

function hideValues(array,hidden)
	for i,v in ipairs(array) do
		for i2,v2 in ipairs(hidden) do
			if v==v2 then
                table.remove(array, i)
                return hideValues(array,hidden)
				--array[i] = nil
			end
		end
	end
end
 
function lineClear()
	local _,y=term.getCursorPos()
	term.clearLine()
	term.setCursorPos(1,y)
end
 
function printCentered(str)
	local termX, _termY=term.getSize()
	local _cursX, cursY=term.getCursorPos()
	local newX = math.ceil(termX/2)-math.ceil(#str/2)
	term.setCursorPos(newX,cursY)
	print(str)
end
 
function replaceDelim(str, delim)
	local result = ''
	for i in string.gmatch(str, '%a+') do
		result=result..i..delim
	end
	return result
end
 
function spacifyTable(array)
	local tmp=array
	for i,v in ipairs(tmp) do
		tmp[i]=replaceDelim(v,' ')
	end
	return tmp
end

function numbersOnly(pre,limit)-- Works like read(), except only accepts numbers. Writes a desired prefix and can accept a max number length
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

function dichotomy(a,b) --Gives a selection of two choices, a or b, returning true for a and false for b
	sel=true
	while true do
		if sel then
			write("[ "..a.." ]    "..b.."  ")
		else
			write("  "..a.."    [ "..b.." ]")
		end
		event,key=os.pullEvent()
		if event == "key" then
			if key == 203 or key == 205 then sel = not sel
			elseif key == 14 then return false
			elseif key == 28 or key==57 then break end
		end
		sleep(0.01)
		lineClear()
	end
	print()
	return sel
end

function header(banner)
	term.clear()
	term.setCursorPos(1,1)
	print("HimCo Industries' Experimental OS")
	local user=loadFromFile('session','./config') or 'Guest'
	print(user,' logged into Computer ID #',os.getComputerID())
	print()
	printCentered(banner)
	print()
end

function footer(text)
	local originalX,originalY=term.getCursorPos()
	local xSize,ySize=term.getSize()
	term.setCursorPos(xSize-1,ySize-1)
	write(text)
	term.setCursorPos(originalX,originalY)
end

function multipleChoice(choices, sel,bottom)
	local size = #choices
	local sel = sel or 1 --initial selection
	if sel>#choices then
		sel=#choices
	end
	local xsize,ysize=term.getSize()
	local xcoord,ycoord=term.getCursorPos()
	local bottom = bottom or 0
	local ysize=ysize-bottom or ysize
	
	local diff=ysize-ycoord
	local interval=1
	while true do
		term.setCursorPos(xcoord,ycoord)
		if sel>=interval+diff then
			interval=sel-diff+1
		elseif sel==interval-1 and interval>1 then
			interval=interval-1
		elseif sel==size and interval==1 then
			interval=size-diff+1
		elseif sel==1 then
			interval=1
		end
		for i=interval, interval+diff-1 do
			lineClear()
			if interval > 1 and sel == interval and i == sel and i<=size and i>=1 then
				printCentered('   [ '..choices[i]..' ]  ^')
			elseif interval > 1 and i == interval and i<=size and i>=1 then
				printCentered('     '..choices[i]..'    ^')
			elseif i == interval + diff -1 and i == sel and i ~= size and i<=size and i>=1 then
				printCentered('   [ '..choices[i]..' ]  v')
			elseif i == interval + diff -1 and i ~= size and i<=size and i>=1 then
				printCentered('     '..choices[i]..'    v')
			elseif i == sel and i<=size and i>=1 then
				printCentered('[ '..choices[i]..' ]')
			elseif i<=size and i>=1 then
				printCentered('  '..choices[i]..'  ')
			end
		end
		--user input
		local event,key=os.pullEvent('key')
		if key == 208 or key == 31 then -- down arrow or S
			sel = sel+1
			if sel > size then
				sel = 1 --bottom reached, moving back to top
			end
		elseif key == 200 or key == 17 then -- up arrow or W
			sel = sel-1
			if sel < 1 then
				sel = size -- top reached, moving to bottom
			end
		elseif key == 209 then 
			if sel+diff<size then
				interval=interval+diff
				sel=interval+diff-1
			else
				sel=size
			end
		elseif key == 201 then -- Page up
			if sel-diff>1 then
				if interval+2*diff<size-1 then
					interval=interval-diff
				else
					interval=size-1
				end
				sel=interval
			else
				sel=1
			end
		elseif key == 28 or key == 57 then -- space or enter
			return sel --input complete
		elseif key == 14 then -- backspace
			return false
		elseif key == 211 then -- Returns true as well as selection when delete is pressed
			return sel,true
		end
	end
end

function loadFromFile(variable,file)
	local file=file or 'config'
	local file_path=fs.open(file,'r')
	local values=unser(file_path.readLine())
	for i,v in pairs(values) do
		if i==variable then
			file_path.close()
			return v
		end
	end
	file_path.close()
	return nil
end

function saveToFile(variable,value,file)
	local file=file or 'config'
	createFile(file)
	local file_path=fs.open(file,'r')
	local values=unser(file_path.readLine())
	values[variable]=value
	file_path.close()
	
	local file_path=fs.open(file,'w')
	file_path.writeLine(ser(values))
	file_path.close()
end

function receiveMessage(delay)-- Same as rednet.receive(), but returns true if sending was successful, false if not
	local delay=delay or 60
	local id,msg,d=rednet.receive(delay)
	if not id then
		return false
	end
	rednet.send(id,true)
	return id,msg,d
end

function sendMessage(id,msg)-- Same as rednet.send(), but sends confirmation of received message
	rednet.send(id,msg,5)
	local tid,tmsg,td=rednet.receive(2)
	if tid==id and tmsg then
		return true
	else
		return false
	end
end

function createFile(name)--Creates a file with filename 'name'
	if not fs.exists(name) then
		print('config does not exist')
		f=fs.open(name,'w')
		f.writeLine('{}')
		f.close()
	end
end
