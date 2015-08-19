term.clear()
term.setCursorPos(1,1)

local function lineClear()
	x,y=term.getCursorPos()
	term.clearLine()
	term.setCursorPos(1,y)
end

local function dichotomy(a,b) --Gives a selection of two choices, a or b, returning true for a and false for b
	sel=true
	while true do
		if sel then
			write("--> "..a.."     "..b)
		else
			write("    "..a.." --> "..b)
		end
		event,key=os.pullEvent()
		if event == "key" then
			if key == 203 or key == 205 then sel = not sel
			elseif key == 28 or key==57 then break end
		end
		sleep(0.01)
		lineClear()
	end
	print()
	return sel
end

local function numbersOnly(pre,limit)-- Works like read(), except only accepts numbers. Writes a desired prefix and can accept a max number length
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
local num=numbersOnly('Give number for collatz: ')
local initial=num
local count=0
local maxV=1
print(num)
if num%2==0 then
	num=num/2
	maxV=math.max(maxV,num)
	print(num)
else
	num=(num*3)+1
	maxV=math.max(maxV,num)
	print(num)
end
sleep(0.3)
count=count+1
while num~=1 do
	if num%2==0 then
		num=num/2
		maxV=math.max(maxV,num)
		print(num)
	else
		num=(num*3)+1
		maxV=math.max(maxV,num)
		print(num)
	end
	sleep(0.1)
	count=count+1
end
print()
print('Went from '..tostring(initial)..' to 1 in '..tostring(count)..' iterations, with a peak value of '..tostring(maxV)..'.')
print()
--sleep(5)
if dichotomy('Retry','Quit') then
	shell.run('Collatz')
else
	os.reboot()
end