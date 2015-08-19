--tables and variables
local choice = fs.list('files')
local listPadding = 2
local hidden = {
	'menu',
}
local args={...}
--functions

local function generateFiles(file,args)
	
	local msg=functions.ser({action='file_server',id=os.getComputerID(),value='list'})
	if not functions.sendMessage(parent_id,msg) then
		errors.noService()
		os.reboot()
	end
	
	local id,msg=functions.receiveMessage(5)
	
	if not errors.noService(id) then
		return false
	end
	
	local values=functions.unser(msg)
	if values['action']=='return' and id==parent_id then
	
		local files=values['value']
		if #files==0 then
			print('There are no files currently on server.')
			sleep(2)
			return false
		end
		
		return files, functions.multipleChoice(files,file,listPadding)
		
	end
end

local function displayFile(file,files,a,b,banner)
	
	functions.header(banner)
	functions.footer('Back = [ backspace ]')
	local x,y=term.getCursorPos()
	
	for i=file,1,-1 do
		term.setCursorPos(x,y+i-1)
		functions.printCentered('[  '..files[file]..'  ]')
		sleep(0.01)
		functions.lineClear()
	end
	
	local x,y=term.getCursorPos()
	print()
	print()
	if not functions.dichotomy(a,b) then
		functions.header(banner)
		functions.footer('Back = [ backspace ]')
		for i=1, file-1 do
			term.setCursorPos(x,y+i-1)
			functions.printCentered('[  '..files[file]..'  ]')
			term.setCursorPos(x,y+i-1)
			sleep(0.01)
			functions.lineClear()
		end
		return false
	else
		return true
	end
end

local function downloadFile(file)

	local msg=functions.ser({action='file_server',id=os.getComputerID(),value='get',value2=file})
	if not functions.sendMessage(parent_id,msg) then
	
		errors.noService()
		os.reboot()
		
	end
	
	local id,msg=functions.receiveMessage()
	local values=functions.unser(msg)
	
	if values['action']=='return' and id==parent_id then
	
		local result=functions.unser(values['value2'])
		--print(result)
		local file_handler=fs.open('./disk/'..file,'w')
		file_handler.write(result)
		file_handler.close()
	
	end	
end

local function uploadFile(file)
	
	local file_path=fs.open('/disk/'..file,'r')
	local content=functions.ser(file_path.readAll())
	
	local msg=functions.ser({action='file_server',id=os.getComputerID(),value='send',value2=file,value3=content,username=functions.loadFromFile('session')})
	if not functions.sendMessage(parent_id,msg) then
		
		errors.noService(_,reaction())
		--os.reboot()
		
	end
	local id,msg=functions.receiveMessage(5)
	
	errors.noService(id,uploadDownloadManage(1))
	
	local values=functions.unser(msg)
	
	return values['action']=='return' and values['value']
	
end

function action()
	local initial=1
	functions.header('Select a file to copy to disk from server:')
	functions.footer('Back = [ backspace ]')
	
	if errors.offline() then
	
		uploadDownloadManage(2)
		
	end
	
	while true do
	
	--local initial=1
	--print(file)
	--sleep(2)
		functions.header('Select a file to copy to disk from server:')
		functions.footer('Back = [ backspace ]')
		local files,file,delete=generateFiles(initial)
		if not file or not files then
			return uploadDownloadManage(2)
		end
		initial=file
		if delete then
			while true do
				
				if displayFile(file,files,'Delete File','Cancel','Are you sure you want to delete this?') then
					local msg=functions.ser({action='file_server',id=os.getComputerID(),value='delete',username=functions.loadFromFile('session'),value2=files[file]})
					--print(files[file])
					functions.sendMessage(parent_id,msg)
					local id,msg=functions.receiveMessage(5)
					errors.noService(id,action())
					
					local values=functions.unser(msg)
					
					if values['value'] then
										
						local x,y=term.getCursorPos()
						term.setCursorPos(x,y-1)
						functions.lineClear()
						print('File ',files[file],' has been deleted.')
						sleep(1)
						break
					else
										
						local x,y=term.getCursorPos()
						term.setCursorPos(x,y-1)
						functions.lineClear()
						print('You do not have permission to delete this file.')
						sleep(1)
						break
					end					
				else
					break
				end
			end
		else
			while true do
				--print(files[file])
				--sleep(2)
				if displayFile(file,files,'Copy to Disk','Cancel','Select a file to copy to disk from server:') then
					if not fs.exists('./disk') then
						local x,y=term.getCursorPos()
						term.setCursorPos(x,y-1)
						functions.lineClear()
						print('No Disk Drive Detected. Please add one and try again.')
						sleep(2)
					elseif fs.exists('./disk/'..files[file]) then
						local x,y=term.getCursorPos()
						term.setCursorPos(x,y-1)
						functions.lineClear()
						print('File already exists on disk.')
						sleep(2)
					else
						--print(files[file])
						downloadFile(files[file])
					
						local x,y=term.getCursorPos()
						term.setCursorPos(x,y-1)
						functions.lineClear()
						print('File saved to disk as ',files[file],'.')
						sleep(2)
						break
					end
				else
					break
				end
			end
		end
	end
end

function reaction()
	local initial=1
	functions.header('Select a file to copy to disk from server:')
	functions.footer('Back = [ backspace ]')
	
	if errors.offline() then
		uploadDownloadManage()
	end
	
	while true do
		functions.header('Select a file to upload to server from the disk:')
		functions.footer('Back = [ backspace ]')
		local files=fs.list('/disk')
			
		if #files==0 then
			print('There are no files on this disk to upload.')
			a,b=os.pullEvent('key')
			return uploadDownloadManage()
		end
		if not files then
			print('No Disk Drive Detected. Please add one then try again.')
			sleep(2)
		else
			local file=functions.multipleChoice(files, initial,listPadding)
			if not file then
				return uploadDownloadManage(1)
			end
			initial=file
			while true do
				--print(files[file])
				--sleep(2)
				if displayFile(file,files,'Upload to Server','Cancel','Select a file to upload to server from the disk:') then
					--print(files[file])
					if uploadFile(files[file]) then
					
						local x,y=term.getCursorPos()
						term.setCursorPos(x,y-1)
						functions.lineClear()
						print('File ',files[file],' successfully uploaded to server.')
						sleep(2)
						break
						
					else
					
						local x,y=term.getCursorPos()
						term.setCursorPos(x,y-1)
						functions.lineClear()
						print('File of same name already exists on server. Rename the file and try again.')
						sleep(2)
						
					end
						
				else
					break
				end
			end	
		end
	end
end

local function manageDisk(sel)
	
	local sel=sel or 1
	
	functions.header('Select an option:')
	functions.footer('Back = [ backspace ]')
	local choices={'Manage Files','Rename Files','Create File'}
	local action=functions.multipleChoice(choices,sel,listPadding)
	
	if not action then
		return uploadDownloadManage(3)
	end	
	
	if action==1 then
		local initial=1
		
		while true do
	
			functions.header('Select a file to view it:')
			functions.footer('Back = [ backspace ]       Delete File = [ del ]')
			local files=fs.list('/disk')
			
			if #files==0 then
				print('There are no files on this disk to manage.')
				a,b=os.pullEvent('key')
				return manageDisk()
			end
			
			local file,delete=functions.multipleChoice(files,initial,listPadding)
			
			if not file then
				return manageDisk()
			end
			
			initial=file
			if not delete then
			
				shell.run('edit','/disk/'..files[file])
				
			else
				while true do
				
					if displayFile(file,files,'Delete File','Cancel','Are you sure you want to delete this?') then
				
						fs.delete('/disk/'..files[file])
						
						local x,y=term.getCursorPos()
						term.setCursorPos(x,y-1)
						functions.lineClear()
						print('File ',files[file],' has been deleted.')
						sleep(1)
						break
						
					else
						break
					end
				end
			end	
		end
		
	elseif action==2 then
		local initial=1
		while true do
	
			functions.header('Select a file to rename it:')
			functions.footer('Back = [ backspace ]')
		
			local files=fs.list('/disk')
			
			local file,delete=functions.multipleChoice(files,initial,listPadding)
			
			if not file then
				return manageDisk(2)
			end
			while true do
			
				if displayFile(file,files,'Rename File','Cancel','Select a file to rename it:') then
					
					write('Give a new name: ')
					local newName=read()
						
					shell.run('rename','/disk/'..files[file],'/disk/'..newName)
					local x,y=term.getCursorPos()
					term.setCursorPos(x,y-2)
					functions.lineClear()
					print('File ',files[file],' has been renamed to ',newName)
					sleep(2)
					initial=file
					break
					
				else
					initial=file
					break
				end
			end
			
		end		
	elseif action==3 then
		functions.header('Create File?')
		functions.footer('Back = [ backspace ]')
		while true do
			if functions.dichotomy('Create File','Cancel') then
				
				write('Give a name: ')
				local newName=read()
				
				if not fs.exists('/disk/'..newName) then
				
					local file=fs.open('/disk/'..newName,'w')
					file.close()
					
					local x,y=term.getCursorPos()
					term.setCursorPos(x,y-2)
					functions.lineClear()
					print('File ',newName,' has been created.')
					sleep(2)
					return manageDisk(3)
				
				else
				
					local x,y=term.getCursorPos()
					term.setCursorPos(x,y-2)
					functions.lineClear()
					print('File ',newName,' already exists.')
					sleep(2)
					return manageDisk(3)
					
				end
			else
				return manageDisk(3)
			end
		end
	end
end

function uploadDownloadManage(sel,choice)
	
	functions.header('Select an option:')
	functions.footer('Back = [ backspace ]')
	local sel=sel or 1
	local choices={'Upload','Download','Manage Disk'}
	local choice=choice or functions.multipleChoice(choices,sel,listPadding)
	if not choice then
		shell.run('menu')
		shell.exit()
	end
	
	if choice==1 then
		reaction()
	elseif choice==2 then
		action()
	elseif choice==3 then
		if not fs.exists('/disk') then
			functions.header('Select an option:')
			print('A disk drive with a valid disk is required for this option.')
			sleep(2)
			return uploadDownloadManage()
		else
			return manageDisk()
		end
	end
	
end

parent_id=functions.loadFromFile('parent_id')
uploadDownloadManage()