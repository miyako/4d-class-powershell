Class extends PowerShellController

Class constructor($signal : 4D.Signal; $command : Variant)
	
	Super()
	
	Case of 
		: (Count parameters=0)
			
			If (OB Instance of(__instance__; cs._MULTIPLE))
				
				$that:=__instance__
				
				$that._terminate()
				
			End if 
			
		: (Count parameters=1)
			
			This.signal:=$signal
			
			This._setupBuffer()
			This._init()
			
		: (Count parameters=2)
			
			If (OB Instance of(__instance__; cs._MULTIPLE))
				
				$that:=__instance__
				
				$that.signal:=$signal
				$that.command:=$command
				
				$that._execute()
				
			End if 
			
	End case 
	
Function onEvent($worker : 4D.SystemWorker)
	
	__instance__:=This
	
	This.signal.trigger()
	
	//MARK: -private
	
Function _init()
	
	This.CLI.chmod()
	
	This.timeout:=This.CLI.timeout
	This.currentDirectory:=This.CLI.currentDirectory
	This.hideWindow:=This.CLI.hideWindow
	This.variables:=This.CLI.variables
	This.encoding:=This.CLI.encoding
	This.dataType:=This.CLI.dataType
	
	This.worker:=4D.SystemWorker.new(This.CLI.executablePath; This)
	This.worker.wait(0)
	
Function _onExecute($worker : 4D.SystemWorker)
	
	$signal:=This.signal
	
	$response:=This.CLI.responseToCollection(This.response.join(""))
	
	Use ($signal)
		$signal.response:=$response.copy(ck shared)
	End use 
	
	$signal.trigger()
	
Function _execute()
	
	This.onEvent:=This._onExecute
	
	This._clearBuffer()
	
	Case of 
		: (Value type(This.command)=Is text)
			
			Case of 
				: (This.dataType="text")
					
					This.worker.postMessage(This.command+This.CLI.EOL)
					
				: (This.dataType="blob")
					
					//must post blob if dataType is blob
					var $data : Blob
					
					CONVERT FROM TEXT(This.command+This.CLI.EOL; This.encoding; $data)
					
/*
INSERT IN BLOB($data; 0; 3)
					
$data{0}:=0x00EF
$data{1}:=0x00BB
$data{2}:=0x00BF
*/
					
					This.worker.postMessage($data)
					
			End case 
			
		: (Value type(This.command)=Is object) && (OB Instance of(This.command; 4D.File)) && (This.command.exists)
			
			If (This.command.exists)
				Case of 
					: (Is macOS)
						This.worker.postMessage(File(This.command.platformPath; fk platform path).path+This.CLI.EOL)
					: (Is Windows)
						This.worker.postMessage(This.command.platformPath+This.CLI.EOL)
				End case 
			End if 
			
		Else 
			This.signal.trigger()
	End case 
	
	This.worker.wait(0)
	
Function _terminate()
	
	This.worker.terminate()
	
	KILL WORKER