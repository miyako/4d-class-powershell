Class constructor
	
	This.CLI:=cs.PowerShell.new()
	
	This.onResponse:=This._script
	This.onData:=This._script
	This.onDataError:=This._script
	This.onError:=This._script
	This.onTerminate:=This._script
	
	//MARK: -virtual
	
Function onEvent($worker : 4D.SystemWorker)
	
	//MARK: -public
	
Function addResponse($command : Text)->$this : cs._SINGLE
	
	$this:=This
	
	This._clearBuffer()
	
	$response:=New object("command"; $command; "response"; This.response)
	
	This.responses.push($response)
	
	//MARK: -private
	
Function _clearBuffer()->$this : cs._SINGLE
	
	$this:=This
	
	This.response:=New collection
	
Function _setupBuffer()->$this : cs._SINGLE
	
	$this:=This
	
	This.responses:=New collection
	
	This._clearBuffer()
	
Function _script($worker : 4D.SystemWorker; $params : Object)
	
	Case of 
		: ($params=Null)
			
		: ($params.type="data") & ($worker.dataType="text")
			
			var $data : Text
			
			$data:=$params.data
			
			Case of 
				: (This.CLI.isEscapeSequence($data))
					
				: (This.CLI.isStartupMessage($data))
					
				: (This.CLI.isPrompted($data))
					
					This.onEvent($worker)
					
				Else 
					This.response.push($data)
			End case 
			
		: ($params.type="error")
			
		: ($params.type="termination")
			
		: ($params.type="response") & ($worker.dataType="text")
			
			For each ($response; This.responses)
				
				$response.response:=Split string($response.response.join(""); This.CLI.EOL; sk ignore empty strings)
				
			End for each 
			
	End case 