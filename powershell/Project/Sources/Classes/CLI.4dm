Class constructor($executableName : Text)
	
	This.name:=OB Class(This).name
	
	Case of 
		: (Is macOS)
			This.platform:="macOS"
			This.executableName:=$executableName
			This.EOL:="\n"
		: (Is Windows)
			This.platform:="Windows"
			This.executableName:=$executableName+".exe"
			This.EOL:="\r\n"
	End case 
	
	This.currentDirectory:=Folder(Get 4D folder(Current resources folder); fk platform path).folder("CLI").folder(This.name).folder(This.platform)
	
	This.encoding:="utf-8"
	
	Case of 
		: (Is macOS)
			This.executablePath:=This.currentDirectory.file(This.executableName).path
		: (Is Windows)
			This.executablePath:=This.currentDirectory.file(This.executableName).platformPath
			This.encoding:="windows-31j"
	End case 
	
	This.hideWindow:=True
	This.variables:=New object
	
	//This.dataType:="blob"
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
	
Function responseToCollection($text : Text)->$response : Collection
	
	$responseText:=This.filterEscapeMode($text)
	
	$response:=Split string($responseText; This.EOL; sk ignore empty strings)
	
Function filterEscapeMode($in : Text)->$out : Text
	
	ARRAY LONGINT($pos; 0)
	ARRAY LONGINT($len; 0)
	
	$i:=1
	
	While (Match regex("(?:\\u001b\\[[0-9?;=#]+[hlm])([^\\u001b]*)"; $in; $i; $pos; $len))
		$out:=$out+Substring($in; $pos{1}; $len{1})
		$i:=$pos{0}+$len{0}
	End while 
	
	$out:=$out+Substring($in; $i)
	
	//https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797
	
Function isEmptyLine($data : Text)->$isEmptyLine : Boolean
	
	$isEmptyLine:=Match regex("(\\r?\\n)+"; $data)