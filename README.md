![version](https://img.shields.io/badge/version-19%20R4%2B-5682DF)
![platform](https://img.shields.io/static/v1?label=platform&message=mac-intel%20|%20win-64&color=blue)
[![license](https://img.shields.io/github/license/miyako/4d-plugin-jwt)](LICENSE)

# 4d-class-powershell
[SystemWorker](https://developer.4d.com/docs/ja/API/SystemWorkerClass.html) + [PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-macos?view=powershell-7.2#binary-archives) example.

#### Class Hierarchy

* [CLI](https://github.com/miyako/4d-class-powershell/blob/main/powershell/Project/Sources/Classes/CLI.4dm): base class for all CLI 
* [PowerShell](https://github.com/miyako/4d-class-powershell/blob/main/powershell/Project/Sources/Classes/PowerShell.4dm): specific to `pwsh`
* [TEST](https://github.com/miyako/4d-class-powershell/blob/main/powershell/Project/Sources/Classes/TEST.4dm): this example

to avoid potential GateKeeper issues, git clone rather than download zip, on Mac.

`pwsh` runs under Rosetta 2. you may replace it with native Apple Silicon distribution if all agents are ARM. currently Microsoft does not release Universal Binary 2 edition of PowerShell.

#### Examples

* create instance, execute lines in sequence

```4d
$steps:=New collection
$steps.push("[System.Net.IPAddress]::Any | ConvertTo-Json")
$steps.push("[System.Net.IPAddress]::Any | ConvertTo-Json")

$responses:=cs.PS1.new($steps).responses
```

* create instance, execute many times in dedicated worker, destroy in the end (more efficient)

```4d
$instance:=cs.PS1.new()

$response:=$instance.command("[System.Net.IPAddress]::Any | ConvertTo-Json")
$response:=$instance.command("[System.Net.IPAddress]::Any | ConvertTo-Json")
$response:=$instance.command("[System.Net.IPAddress]::Any | ConvertTo-Json")

$instance.terminate()
```
