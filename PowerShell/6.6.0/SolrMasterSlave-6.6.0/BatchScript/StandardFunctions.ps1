Function Pause (
    $Message = "(PS) Press any key to continue . . . "
){
    if ((Test-Path variable:psISE) -and $psISE) {
        $Shell = New-Object -ComObject "WScript.Shell"
        $Button = $Shell.Popup("Click OK to continue.", 0, "Script Paused", 0)
    }
    else {     
        Write-Host -NoNewline $Message
        [void][System.Console]::ReadKey($true)
        Write-Host
    }
}


Function Write-Host-H1(
    [string]$Message
){
    Write-Host -NoNewline "---" -ForegroundColor White -BackgroundColor Green
    Write-Host -NoNewline " $Message "
    Write-Host "----" -ForegroundColor White -BackgroundColor Green
}


Function Write-Host-H2(
    [string]$Message
){
    Write-Host -NoNewline "---" -ForegroundColor White -BackgroundColor Blue
    Write-Host -NoNewline " $Message "
    Write-Host "----" -ForegroundColor White -BackgroundColor Blue
}

Function Write-Host-Param(
    [string]$ParamName,
    [string]$Value
){
    Write-Host -NoNewline "  >" -ForegroundColor Black -BackgroundColor Yellow
    Write-Host -NoNewline "$ParamName -> "
    Write-Host $Value -ForegroundColor White
}

Function ProceedYN (
    [string]$Message
) {
    if ($Quiet -eq 1) {return $true}
    Write-Host
    $answer = Read-Host "$Message ?(y/n)"
    return ($answer -eq 'y')
}

# Determines if a Service exists with a name as defined in $ServiceName.
# Returns a boolean $True or $False.
Function ServiceExists([string] $ServiceName) {
	Write-Host
	Write-Host-H2 -Message "func ServiceExists"
    foreach ($key in $MyInvocation.BoundParameters.keys)
    {
        $value = (get-variable $key).Value 
        Write-Host-Param -ParamName $key -Value $value
    }
	Write-Host

    [bool] $Return = $False
    # If you use just "Get-Service $ServiceName", it will return an error if 
    # the service didn't exist.  Trick Get-Service to return an array of 
    # Services, but only if the name exactly matches the $ServiceName.  
    # This way you can test if the array is emply.
    if ( Get-Service "$ServiceName*" -Include $ServiceName ) {
        $Return = $True
    }
    $color = 
    Write-Host "ServiceExists($ServiceName): $Return" -ForegroundColor $(if ($Return) {"Green"} else {"Red"})
    Return $Return
}

# Determines if a Service exists with a name as defined in $ServiceName.
# Returns a boolean $True or $False.
Function GetServiceStatus([string] $ServiceName) {
	Write-Host
	Write-Host-H2 -Message "func GetServiceStatus"
    foreach ($key in $MyInvocation.BoundParameters.keys)
    {
        $value = (get-variable $key).Value 
        Write-Host-Param -ParamName $key -Value $value
    }
	Write-Host

    [string] $Return = $null
    # If you use just "Get-Service $ServiceName", it will return an error if 
    # the service didn't exist.  Trick Get-Service to return an array of 
    # Services, but only if the name exactly matches the $ServiceName.  
    # This way you can test if the array is emply.
    if ( Get-Service "$ServiceName*" -Include $ServiceName ) {
        $service = Get-Service -Name "$ServiceName"
        $Return = $service.Status
    }
    Write-Host "GetServiceStatus($ServiceName): $Return" -ForegroundColor Green
    Return $Return
}



function Read-InstallConfigFile([string]$configPath)
{
	Write-Host
	Write-Host-H2 -Message "func Read-InstallConfigFile"
    foreach ($key in $MyInvocation.BoundParameters.keys)
    {
        $value = (get-variable $key).Value 
        Write-Host-Param -ParamName $key -Value $value
    }
	Write-Host

    if ([string]::IsNullOrEmpty($configPath))
    {
        [xml]$configXml = Get-Content ($scriptDir + "\SolrForSitecore.config")
    }
    else
    {
        if (Test-Path $configPath)
        {
            [xml]$configXml = Get-Content ($configPath)
        }
        else
        {
            Write-Message "Could not find configuration file at specified path: $configPath" "Red" -WriteToLog $FALSE -HostConsoleAvailable $hostScreenAvailable
        }
    }

    return $configXml
}


function Get-ConfigOption([xml]$config, [string]$optionName, [bool]$isAttribute=$FALSE)
{
	Write-Host
	Write-Host-H2 -Message "func Get-ConfigOption"
    foreach ($key in $MyInvocation.BoundParameters.keys)
    {
        $value = (get-variable $key).Value 
        Write-Host-Param -ParamName $key -Value $value
    }
	Write-Host

    $optionValue = $FALSE

    if ($isAttribute)
    {
        $attributeName = Split-Path -Leaf $optionName
        $optionName = Split-Path $optionName
        $optionName = $optionName.Replace("\", "//")
        $node = $config.InstallSettings.SelectSingleNode($optionName)

        if ($node -ne $null)
        {
            $attributeValue = $node.GetAttribute($attributeName).Trim()
            if (!([string]::IsNullOrEmpty($attributeValue)))
            {
                $optionValue = [System.Convert]::ToBoolean($attributeValue)
            }
        }
    }
    else
    {
        $nodeValue = $config.InstallSettings.SelectSingleNode($optionName).InnerText.Trim()
        if (!([string]::IsNullOrEmpty($nodeValue)))
        {
            $optionValue = [System.Convert]::ToBoolean($nodeValue)
        }
    }

    return $optionValue
}

Function CreateSymLink (
    [Parameter(mandatory=$true)]
    [string]$link,
    [Parameter(mandatory=$true)]
    [string]$target
)
{
	Write-Host
	Write-Host-H2 -Message "func CreateSymLink"
    foreach ($key in $MyInvocation.BoundParameters.keys)
    {
        $value = (get-variable $key).Value 
        Write-Host-Param -ParamName $key -Value $value
    }
	Write-Host
    
    Try {
       if (-Not(Test-Path $target))
       {
            Write-Host "$target path doens't exixts !" -ForegroundColor red
       } elseif (Test-Path $link){
            Write-Host "$link path already exists!" -ForegroundColor red
       } else {
            Write-Host Creating SymLink $link to $target... -ForegroundColor Black -BackgroundColor White
            New-Item -Path $link -ItemType SymbolicLink -Value $target
            Write-Host SymLink created -ForegroundColor Green
       }
    }
    Catch
    {
        Write-Warning $_.Exception.Message
        throw  
    }
}