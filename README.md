![version](https://img.shields.io/badge/version-19%20R4%2B-5682DF)
[![license](https://img.shields.io/github/license/miyako/4d-plugin-jwt)](LICENSE)

# 4d-class-powershell
[SystemWorker](https://developer.4d.com/docs/ja/API/SystemWorkerClass.html) + [PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-macos?view=powershell-7.2#binary-archives) example

```4d
Class constructor
	
	This.CLI:=cs.PowerShell.new()
	
	This.onResponse:=This.script
	This.onData:=This.script
	This.onDataError:=This.script
	This.onError:=This.script
	This.onTerminate:=This.script
	
Function run()->$this : cs.TEST
	
	$this:=This
	
	This.data:=New collection
	
	This.started:=False
	This.ended:=False
	
	This.steps:=New collection
	
	This.steps.push("[System.Net.IPAddress]::Any | ConvertTo-Json -Compress")
	
	This.CLI.execute($this)
	
Function script($worker : 4D.SystemWorker; $params : Object)
	
	Case of 
		: ($params.type="response")
			
		: ($params.type="data") & ($worker.dataType="text")
			
			var $data : Text
			
			$data:=$params.data
			
			Case of 
				: ($data="PowerShell@Type 'help' to get help.")
					
				: (Match regex("\\n+"; $data))
					
				: (Match regex("\\u001B\\[\\?1l"; $data))
					
					This.started:=True
					
				: (Match regex("\\u001B\\[\\?1h"; $data))
					
				: (Match regex("PS .+?> "; $data)) & (Not(This.ended))
					
					Case of 
						: (This.steps.length#0)
							
							$worker.postMessage(This.steps.shift())
							$worker.closeInput()
							$worker.wait(0)
							
						Else 
							
							This.ended:=True
							
					End case 
					
				: (This.started) & (Not(This.ended))
					
					This.data.push($data)
					
			End case 
			
		: ($params.type="error")
			
		: ($params.type="termination")
			
	End case 
```
