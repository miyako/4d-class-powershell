Class extends PowerShellController

Class constructor
	
	Super()
	
Function run($steps : Collection)->$this : cs._SINGLE
	
	$this:=This
	
	This.steps:=$steps
	
	This._setupBuffer()
	
	This.CLI.execute($this)
	
Function onEvent($worker : 4D.SystemWorker)
	
	Case of 
		: (This.steps.length#0)
			
			$command:=This.steps.shift()
			
			This.addResponse($command)
			
			$worker.postMessage($command+This.CLI.EOL)
			
			$worker.wait(0)
			
		Else 
			
			$worker.closeInput()
			
	End case 