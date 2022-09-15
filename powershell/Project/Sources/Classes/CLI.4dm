Class constructor($executableName : Text)
	
	This.name:=OB Class(This).name
	
	Case of 
		: (Is macOS)
			This.platform:="macOS"
			This.executableName:=$executableName
		: (Is Windows)
			This.platform:="Windows"
			This.executableName:=$executableName+".exe"
	End case 
	
	This.currentDirectory:=Folder(Get 4D folder(Current resources folder); fk platform path).folder("CLI").folder(This.name).folder(This.platform)
	
	Case of 
		: (Is macOS)
			This.executablePath:=This.currentDirectory.file(This.executableName).path
		: (Is Windows)
			This.executablePath:=This.currentDirectory.file(This.executableName).platformPath
	End case 
	
	This.hideWindow:=True
	This.variables:=New object
	This.encoding:="utf-8"
	This.dataType:="text"
	
Function chmod()
	
	If (Is macOS)
		If (Application type=4D Remote mode)
			SET ENVIRONMENT VARIABLE("_4D_OPTION_CURRENT_DIRECTORY"; This.currentDirectory.platformPath)
			SET ENVIRONMENT VARIABLE("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"; "true")
			LAUNCH EXTERNAL PROCESS("chmod +x "+This.executableName)
		End if 
	End if 
	
Function execute($options : Object)
	
	This.chmod()
	
	4D.SystemWorker.new(This.executablePath; $options).wait()