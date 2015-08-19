--shell.run('cd','/')
local files=fs.list('/files/Fun_Files')
if #files==0 then
	functions.header('There are no files here.')
	sleep(2)
	shell.run('menu',1)
	shell.exit()
end
local sel=1
while true do
	functions.header('Select a File:')
	functions.footer('Back = [ backspace ]')
	local file=functions.multipleChoice(files,sel,2)
	
	if not file then
		shell.run('menu')
		--shell.exit()
	end
	
	local sel=file
	shell.run('/files/Fun_Files/'..files[file])
	--shell.exit()
end