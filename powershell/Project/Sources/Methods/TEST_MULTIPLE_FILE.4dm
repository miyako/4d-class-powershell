//%attributes = {}
ASSERT("1940"<=Application version; "19 R4+ required!")

$file:=Folder(fk resources folder).folder("ps1").file("test.ps1")

$instance:=cs.PS1.new()

$response:=$instance.command($file)
$response:=$instance.command($file)
$response:=$instance.command($file)

$instance.terminate()
