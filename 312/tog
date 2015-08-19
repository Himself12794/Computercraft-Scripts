args={...}
rednet.open('top')
coreid=311
if args[1]=='move' and (args[2]=='true' or args[2]=='false') then
	args=textutils.serialize(args)
	rednet.send(coreid,args,true)
elseif args[1]=='place' and (args[2]=='true' or args[2]=='false') then
	args=textutils.serialize(args)
	rednet.send(coreid,args,true)	
elseif args[1]=='battery' and (args[2]=='true' or args[2]=='false') then
	args=textutils.serialize(args)
	rednet.send(coreid,args,true)
end
id,msg,d=rednet.receive(5)
print(msg)
