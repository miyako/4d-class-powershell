![version](https://img.shields.io/badge/version-19%20R4%2B-5682DF)
![platform](https://img.shields.io/static/v1?label=platform&message=mac-intel%20|%20win-64&color=blue)
[![license](https://img.shields.io/github/license/miyako/4d-plugin-jwt)](LICENSE)

# 4d-class-powershell
[SystemWorker](https://developer.4d.com/docs/ja/API/SystemWorkerClass.html) + [PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-macos?view=powershell-7.2#binary-archives) example.

#### Classes

* [CLI](https://github.com/miyako/4d-class-powershell/blob/main/powershell/Project/Sources/Classes/CLI.4dm): base class for all CLI 
\> [PowerShell](https://github.com/miyako/4d-class-powershell/blob/main/powershell/Project/Sources/Classes/PowerShell.4dm): specific to `pwsh`
* [PowerShellController](https://github.com/miyako/4d-class-powershell/blob/main/powershell/Project/Sources/Classes/PowerShellController.4dm): interface to `PowerShell`
* [PS1](https://github.com/miyako/4d-class-powershell/blob/main/powershell/Project/Sources/Classes/PS1.4dm): interface to worker

to avoid potential GateKeeper issues, git clone rather than download zip, on Mac.

`pwsh` runs under Rosetta 2. you may replace it with native Apple Silicon distribution if all agents are ARM. currently Microsoft does not release Universal Binary 2 edition of PowerShell.

filtering of [escape sequences](https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797) is pretty basic.

```4d
While (Match regex("(?:\\u001b\\[[0-9?;=#]+[hlm])([^\\u001b]*)"; $in; $i; $pos; $len))
	$out:=$out+Substring($in; $pos{1}; $len{1})
	$i:=$pos{0}+$len{0}
End while 
```

#### Examples

* create instance, execute lines in sequence

```4d
$steps:=New collection
$steps.push("[System.Net.IPAddress]::Any | ConvertTo-Json")

$responses:=cs.PS1.new($steps).responses
```

* create instance, execute many times in dedicated worker, destroy in the end (more efficient)

```4d
$instance:=cs.PS1.new()

$response_1:=$instance.command("Get-Command")
$response_2:=$instance.command("Get-TimeZone")
$response_3:=$instance.command("Get-Date")
$response_4:=$instance.command("Get-Process | Sort-Object CPU -Descending | Select-Object -First 5"

$instance.terminate()
```

* same, with file object

```4d
$file:=Folder(fk resources folder).folder("ps1").file("test.ps1")

$instance:=cs.PS1.new()

$response:=$instance.command($file)

$instance.terminate()
```

---

**出典**: [2つの日付の差](https://qiita.com/ryosuke0825/items/06eae2e99f587b5275aa#2つの日付の差)

<img width="934" alt="スクリーンショット 0004-09-21 22 56 36" src="https://user-images.githubusercontent.com/1725068/191523812-79a8b6e1-5c2d-42f1-a92b-0b58264df850.png">

