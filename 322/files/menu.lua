--tables and variables
local args={...}
local choice = fs.list('files')
local newTable = fs.list('files')
local sel=args[1] or sel
local hidden = {
	'menu',
	'Fun_Files',
}
 
--actual program
functions.header('Select an option:')
functions.footer('Back = [ backspace ]')
functions.hideValues(choice,hidden)
functions.spacifyTable(choice)
local file=functions.multipleChoice(choice,1,2)
if not file then
	os.reboot()
end
functions.hideValues(newTable,hidden)
shell.run(newTable[file])
shell.exit()