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
	
	This.worker:=4D.SystemWorker.new(This.CLI.executablePath; This)
	This.worker.wait(0)
	
Function _onExecute($worker : 4D.SystemWorker)
	
	$signal:=This.signal
	
	$response:=Split string(This.response.join(""); This.CLI.EOL; sk ignore empty strings)
	
	Use ($signal)
		$signal.response:=$response.copy(ck shared)
	End use 
	
	$signal.trigger()
	
Function _execute()
	
	This.onEvent:=This._onExecute
	
	Case of 
		: (Value type(This.command)=Is text)
			
			This.worker.postMessage(This.command+This.CLI.EOL)
			
		: (Value type(This.command)=Is object)
			
			Case of 
				: (OB Instance of(This.command; 4D.File))
					
					Case of 
						: (Is macOS)
							This.worker.postMessage(File(This.command.platformPath; fk platform path).path+This.CLI.EOL)
						: (Is Windows)
							This.worker.postMessage(This.command.platformPath+This.CLI.EOL)
					End case 
			End case 
			
		Else 
			
	End case 
	
	This.worker.wait(0)
	
Function _terminate()
	
	This.worker.terminate()
	
	KILL WORKER