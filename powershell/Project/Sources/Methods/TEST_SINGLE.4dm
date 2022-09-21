//%attributes = {}
ASSERT("1940"<=Application version; "19 R4+ required!")

$steps:=New collection
$steps.push("[System.Net.IPAddress]::Any | ConvertTo-Json")
$steps.push("[System.Net.IPAddress]::Any | ConvertTo-Json")
$steps.push("[System.Net.IPAddress]::Any | ConvertTo-Json")

$responses:=cs.PS1.new($steps).responses