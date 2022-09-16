Class extends CLI

Class constructor
	
	Super("pwsh")
	
Function isPrompted($data : Text)->$isPrompted : Boolean
	
	$isPrompted:=Match regex("(?ms:.*^)PS .+?> (\\u001B.+)?"; $data)
	
Function isStartupMessage($data : Text)->$isStartupMessage : Boolean
	
	$isStartupMessage:=($data="PowerShell@Type 'help' to get help.")
	