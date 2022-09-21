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