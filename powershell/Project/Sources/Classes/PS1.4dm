Class constructor($steps : Collection)
	
	Case of 
		: (Count parameters=0)
			
			$signal:=New signal
			
			This.name:=Generate UUID
			
			CALL WORKER(This.name; Formula(cs._MULTIPLE.new($1)); $signal)
			
			$signal.wait()
			
		Else 
			
			This.responses:=cs._SINGLE.new().run($steps).responses
			
	End case 
	
Function command($command : Variant)->$response : Collection
	
	$signal:=New signal
	
	CALL WORKER(This.name; Formula(cs._MULTIPLE.new($1; $2)); $signal; $command)
	
	$signal.wait()
	
	$response:=$signal.response
	
Function terminate()
	
	CALL WORKER(This.name; Formula(cs._MULTIPLE.new()))