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
	
Function _clearDataBuffer()->$this : cs._SINGLE
	
	$this:=This
	
	var $bytes : Blob
	
	This.bytes:=$bytes
	
Function _appendDataBuffer($data : Blob)->$this : cs._SINGLE
	
	$this:=This
	
	var $bytes : Blob
	
	$bytes:=This.bytes  //copy mutable
	COPY BLOB($data; $bytes; 0; BLOB size($bytes); BLOB size($data))
	This.bytes:=$bytes  //copy immutable
	
Function _clearBuffer()->$this : cs._SINGLE
	
	$this:=This
	
	This.response:=New collection
	
	This._clearDataBuffer()
	
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
				: (This.CLI.isStartupMessage($data))
					
				: (This.CLI.isPrompted($data))
					
					This.onEvent($worker)
					
				Else 
					This.response.push($data)
			End case 
			
		: ($params.type="data") & ($worker.dataType="blob")
			
			var $data : Text
			
			$data:=Convert to text($params.data; This.encoding)
			
			Case of 
				: (This.CLI.isStartupMessage($data))
					
				: (This.CLI.isPrompted($data))
					
					This.response.push(Convert to text(This.bytes; This.encoding))
					
					This._clearDataBuffer()
					
					This.onEvent($worker)
					
				Else 
					
					This._appendDataBuffer($params.data)
					
			End case 
			
		: ($params.type="error")
			
		: ($params.type="termination")
			
		: ($params.type="response")
			
			For each ($response; This.responses)
				
				$response.response:=This.CLI.responseToCollection($response.response.join(""))
				
			End for each 
			
	End case 