Class constructor
	
	This.CLI:=cs.PowerShell.new()
	
	This.onResponse:=This.script
	This.onData:=This.script
	This.onDataError:=This.script
	This.onError:=This.script
	This.onTerminate:=This.script
	
Function _clearBuffer()->$this : cs.TEST
	
	$this:=This
	
	This.response:=New collection
	
Function addResponse($command : Text)->$this : cs.TEST
	
	$this:=This
	
	This._clearBuffer()
	
	$response:=New object("command"; $command; "response"; This.response)
	
	This.responses.push($response)
	
Function _setupBuffer()->$this : cs.TEST
	
	$this:=This
	
	This.responses:=New collection
	
	This._clearBuffer()
	
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
				: (This.CLI.isEmptyLine($data))
					
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
			
	End case 