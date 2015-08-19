args={...}
rednet.open('top')

function receiveMessage()
	local id,msg,d=rednet.receive()
	rednet.send(id,true)
	return id,msg,d
end

function sendMessage(id,msg)
	if id='broadcast' then
		rednet.broadcast(msg)
	else
		rednet.send(id,msg,5)
	end
	local tid,tmsg,td=rednet.receive(5)
	if tid==id and msg then
		return true
	else
		return false
	end
end

-- function findRouter()
	-- if sendMessage('broadcast','find router') then
		-- print('Response received')
	-- if msg=='find router' then
		-- id,msg,d=rednet.receive(3)
		-- print('Response received')
	-- elseif msg==true then
		-- print('Router access granted')
		-- print('Router id is '..tostring(id))
		-- return id
	-- else
		-- print('Router access denied or unavailable')
		-- return false
	-- end
-- end

-- function routedMessage(id,msg)
	-- local temp={id,msg}
	-- local temp=textutils.serialize(temp)
	-- local router=findRouter()
	-- print(router)
	-- sleep(0.02)
	-- if router==false then
		-- print('Router access unavailable or denied')
		-- return false
	-- elseif rednet.send(router,temp) then
		-- return true
	-- else
		-- return false
	-- end
	-- sleep(0.03)
	-- id1,msg1,d1=rednet.receive(3)
	-- print(id1)
	-- if msg==true then
		-- print('Target has received message')
	-- end
-- end

-- routedMessage(tonumber(args[1]),args[2])
