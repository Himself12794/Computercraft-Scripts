local function header(banner)
	term.clear()
	term.setCursorPos(1,1)
	print("HimCo Industries' Experimental OS")
	--print(loadFromFile('session','./config'),' logged into Computer ID #',os.getComputerID())
	print()
	printCentered(banner)
	print()
end
 
local function lineClear()
	local _,y=term.getCursorPos()
	term.clearLine()
	term.setCursorPos(1,y)
end
 
function printCentered(str)
	local termX, _termY=term.getSize()
	local _cursX, cursY=term.getCursorPos()
	local newX = math.ceil(termX/2)-math.ceil(string.len(str)/2)
	term.setCursorPos(newX,cursY)
	print(str)
end

function footer(text)
	local originalX,originalY=term.getCursorPos()
	local xSize,ySize=term.getSize()
	term.setCursorPos(1,ySize-1)
	lineClear()
	write(text)
	term.setCursorPos(originalX,originalY)
end

local function multipleChoice(choices, sel,bottom)
	local size = #choices
	local sel = sel or 1 --initial selection
	if sel>#choices then
		sel=#choices
	end
	local xsize,ysize=term.getSize()
	local xcoord,ycoord=term.getCursorPos()
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
			footer('sel='..tostring(sel)..' interval='..tostring(interval))
			lineClear()
			if interval > 1 and sel == interval and i == sel then
				printCentered('   [ '..choices[i]..' ]  ^')
			elseif interval > 1 and i == interval then
				printCentered('     '..choices[i]..'    ^')
			elseif i == interval + diff -1 and i == sel and i ~= size then
				printCentered('   [ '..choices[i]..' ]  v')
			elseif i == interval + diff -1 and i ~= size then
				printCentered('     '..choices[i]..'    v')
			elseif i == sel then
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
header('What?')
choices={'po','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','aa','ab','ac','ad','1','2','3','4','5','6','7'}
choice=multipleChoice(choices,1,2)
print(choices[choice])