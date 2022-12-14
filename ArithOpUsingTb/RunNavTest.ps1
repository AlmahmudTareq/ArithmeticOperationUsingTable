param (
                                    [string]$Instance       ="BC190",
                                    [string]$Company        = "CRONUS Danmark",
                                    [int]   $CodeUnitNo     = 50105,
                                    [int]   $BuildNo        = 0,
                                    [string]$ResultPath     = "",
                                    [string]$Prefix         = "",
                                    [string]$HostName       = "http://localhost:8080/BC190/",
                                    [switch]$UseDocker      = $false
 )

Write-Host "Starting RunNavTest.ps1 with the following arguments:"
Write-Host "  HostName:     " $HostName.ToString()
Write-Host "  Instance:     " $Instance.ToString()
Write-Host "  Company:      " $Company.ToString()
Write-Host "  CodeUnitNo:   " $CodeUnitNo.ToString()
Write-Host "  BuildNo:      " $BuildNo.ToString()
Write-Host "  ResultPath:   " $ResultPath.ToString()
Write-Host "  Prefix:       " $Prefix.ToString()
Write-Host "  UseDocker:    " $UseDocker.ToString()

# Include B365 NAV tools script
. "E:\Leasing APplication\b365\b365\build\scripts\B365NavTools.ps1"

if($UseDocker -eq $true) {
    $Parameters = @{
        "HostName"      = $Instance
        "Instance"      = "NAV"
        "Company"       = $Company
        "ObjectType"    = "CodeUnit"
        "ObjectID"      = $CodeUnitNo
        "ClientPath"    = "D:\BCClient\Microsoft.Dynamics.Nav.Client.exe"
    }
    $ec = Start-B365NAVInConsoleMode @Parameters
} else {
    $Parameters = @{
        "HostName"      = "localhost:8080"
        "Instance"      = "BC190"
        "Company"       = "CRONUS Danmark"
        "ObjectType"    = "CodeUnit"
        "ObjectID"      = 50105
        "ClientPath"    = "D:\BCClient\Microsoft.Dynamics.Nav.Client.exe"
    }
    $ec = Start-B365NAVInConsoleMode @Parameters
}

if($ec -eq -2146232797) {
    # Ignore warning about modal popup...
    $ec = 0
}

if($ec -eq 255) {
    # Microsoft.Dynamics.Nav.Client sometimes return 255, even when everything seems to be OK
    $ec = 0
}

if($ec -eq 0) {
    $TableName = "dbo.[$Company"+"$"+"CAL Test Line]"
    $TableName = $TableName.Replace("/", "_");
    
    if($UseDocker -eq $true) {
        $result = Invoke-Sqlcmd -ServerInstance $Instance -Database "CronusDK" -ConnectionTimeout 60 -Query "SELECT * FROM $TableName"
    } else {
        $result = Invoke-Sqlcmd -ServerInstance $HostName -Database $Instance -ConnectionTimeout 60 -Query "SELECT * FROM $TableName"
    }

    if($result.count -eq 0) {
        $ec = 2
    } else {
        ForEach($i in $result) { 
            if($i."line type" -eq 2) {
                $i.name = "  " + $i.name
            }
            if(($i.run -eq 1) -and ($i.Result -eq 1)) {
                $ec = 1;
            }
        }
    }

    if(-Not($ResultPath -eq "")) {
        $DateStr        = (Get-Date -format yyyy.MM.dd).ToString()
        $ResultFile     = $ResultPath + "\"
        if(-Not($Prefix -eq "")) {
            $ResultFile = $ResultFile + $Prefix + "_"
        }
        $ResultFile = $ResultFile + $DateStr
        if(-Not($BuildNo -eq 0)) {
            $ResultFile = $ResultFile + "_" + $BuildNo
        }
        $ResultFile = $ResultFile + ".txt"
    
        $NameCollumnWidth = 30
        $result | Format-Table "Test Suite", "Test Codeunit", @{ Label="Name"; Expression={if($_.name.length -gt $NameCollumnWidth) { $_.name.substring(0, $NameCollumnWidth)} else {$_.name}}}, "Run", "Result", "Finish time", "First error" | Out-File $ResultFile
        Write-host "Test results:"
        Get-Content -Path $ResultFile
    }
   
}

Write-Host "Script completed with error code:" ($ec).ToString()
exit $ec
