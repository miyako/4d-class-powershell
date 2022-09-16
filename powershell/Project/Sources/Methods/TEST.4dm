//%attributes = {}
$steps:=New collection
$steps.push("[System.Net.IPAddress]::Any | ConvertTo-Json")
$steps.push("[System.Net.IPAddress]::Any | ConvertTo-Json")

$responses:=cs.TEST.new().run($steps).responses
