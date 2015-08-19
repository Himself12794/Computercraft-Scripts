rednet.open('right')
receivingid=321
function input()
	while true do
		p=peripheral.wrap('left')
		p.setFreq(5)
		x=rs.getInput('bottom')
		print(x)
		z=p.get()
		print(z)
		xz={x,z}
		xz=textutils.serialize(xz)
		rednet.send(receivingid,xz)
		sleep(10)
	end
end
input()