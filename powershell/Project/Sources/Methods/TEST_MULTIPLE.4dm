//%attributes = {}
ASSERT("1940"<=Application version; "19 R4+ required!")

$instance:=cs.PS1.new()

$response:=$instance.command("[System.Net.IPAddress]::Any | ConvertTo-Json")
$response:=$instance.command("[System.Net.IPAddress]::Any | ConvertTo-Json")
$response:=$instance.command("[System.Net.IPAddress]::Any | ConvertTo-Json")

$instance.terminate()