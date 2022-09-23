//%attributes = {}
ASSERT("1940"<=Application version; "19 R4+ required!")

$file:=Folder(fk resources folder).folder("ps1").file("test.ps1")

$instance:=cs.PS1.new()

$response_0:=$instance.command("[String]::Format(\"数値を16進表示: {0:x}\", 1234)")


$response_1:=$instance.command("Get-Command")
$response_2:=$instance.command("Get-TimeZone")
$response_3:=$instance.command("Get-Date")
$response_4:=$instance.command("Get-Process | Sort-Object CPU -Descending | Select-Object -First 5")

$response:=$instance.command($file)
$response:=$instance.command($file)
$response:=$instance.command($file)

$instance.terminate()