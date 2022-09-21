//%attributes = {}
ASSERT("1940"<=Application version; "19 R4+ required!")

$steps:=New collection
$steps.push("[System.Net.IPAddress]::Any | ConvertTo-Json")
$steps.push("[System.Net.IPAddress]::Any | ConvertTo-Json")

$responses:=cs.TEST.new().run($steps).responses




$psWorker:=cs.PSWorker.new()

var $ps1 : 4D.File

$ps1:=Folder(fk resources folder).folder("ps1").file("test.ps1")

$code:=$ps1.getText()



$psWorker.executeFile($ps1)
