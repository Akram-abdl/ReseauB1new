function Is-Numeric ($Value) {
    return $Value -match "^[\d\.]+$"
}

function Do-WhatIWant {
    param (
        [Parameter(Mandatory = $true, HelpMessage = "Please enter action : Lock | Shutdown")]
        [string] $Action
        ,
        [Parameter(Mandatory = $true, HelpMessage = "Please enter a time")]
        [string] $Time
    )

    if (-Not (Is-Numeric($Time)) -or $Time -lt 0) {
        Write-Output "Wrong Time"
        Break Script
    }

    if ($Action -eq "Lock") {
        Start-Sleep -Seconds $Time
        rundll32.exe user32.dll, LockWorkStation
    }
    elseif ($Action -eq "Shutdown") {
        shutdown -s -t $Time

    }
    else {
        Write-Output "Wrong Action"
    }
}

Write-Output "Please enter action : Lock | Shutdown"
Write-Output "Please enter time : 0 or greater"

Do-WhatIWant