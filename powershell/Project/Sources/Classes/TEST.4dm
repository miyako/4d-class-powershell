Class extends PowerShellController

Class constructor
	
	Super()
	
Function run($steps : Collection)->$this : cs.TEST
	
	$this:=This
	
	This.steps:=$steps
	
	This._setupBuffer()
	
	This.CLI.execute($this)
	
Function execute($worker : 4D.SystemWorker)
	
	Case of 
		: (This.steps.length#0)
			
			$command:=This.steps.shift()
			
			This.addResponse($command)
			
			$worker.postMessage($command+This.CLI.EOL)
			//do not closeInput() here! it will terminate the CLI
			$worker.wait(0)
			
		Else 
			
			$worker.closeInput()  //→response→termination
			
	End case 
	
Function script($worker : 4D.SystemWorker; $params : Object)
	
	Case of 
		: ($params.type="data") & ($worker.dataType="text")
			
			var $data : Text
			
			$data:=$params.data
			
			Case of 
				: (This.CLI.isEscapeSequence($data))
					
				: (This.CLI.isStartupMessage($data))
					
				: (This.CLI.isPrompted($data))
					
					This.execute($worker)
					
				Else 
					This.response.push($data)
			End case 
			
		: ($params.type="error")
			
		: ($params.type="termination") & ($worker.dataType="text")
			
		: ($params.type="response") & ($worker.dataType="text")
			
			For each ($response; This.responses)
				
				$response.response:=Split string($response.response.join(""); This.CLI.EOL; sk ignore empty strings)
				
			End for each 
			
	End case 