param(
    [string]$configPath, 
    [int]$Quiet = 0
)

# Load functions
$stdFuntionsPath = (split-path -parent $PSCommandPath)
. "$stdFuntionsPath\StandardFunctions.ps1"
. "$stdFuntionsPath\SolrFunctions.ps1"

Clear-Host
#$cd = $(Get-Location)
$cd = $PSScriptRoot | split-path -parent


Write-Host-H1 -Message "Install Solr using $configPath"

Write-Host-Param -ParamName "Script file root" -Value $PSScriptRoot
Write-Host-Param -ParamName "Current directory (cd)" -Value $cd
Write-Host

foreach ($key in $MyInvocation.BoundParameters.keys)
{
    $value = (get-variable $key).Value 
    Write-Host-Param -ParamName $key -Value $value
}


try {
    if(-not($configPath)) { Throw "You must supply a value for -configPath" }
    
    [xml]$configXml = Read-InstallConfigFile -configPath $cd\SolrForSitecore.config  
    $SitecoreIndexNames = $configXml.InstallSettings.ConfigSets.ConfigSet 
    
    $installMaster = $(Get-ConfigOption -config $configXml -optionName "MasterSettings/enabled" -isAttribute $TRUE)
    Write-Host installMaster=$installMaster 
    $installSlave = $(Get-ConfigOption -config $configXml -optionName "SlaveSettings/enabled" -isAttribute $TRUE)
    Write-Host installSlave=$installSlave

    if ($installMaster -eq "true") {
        $masterSettings = $configXml.InstallSettings.MasterSettings
        [string]$serviceName = $masterSettings.ServiceName
        [string]$serviceDisplayName = $masterSettings.ServiceDisplayName
        [int]$servicePort = [int]$masterSettings.ServicePort
        [string]$solrPath = $masterSettings.SolrPath
        [int]$isSlave = 0
    
        Invoke-Expression "$PSScriptRoot\InstallAndStartSolr6Service.ps1 -serviceName $serviceName -serviceDisplayName `"$serviceDisplayName`" -servicePort $servicePort -solrPath $solrPath -Quiet $Quiet -isSlave $isSlave -clearHost 0"
    }
     
    if ($installSlave -eq "true") {
        $slaveSettings = $configXml.InstallSettings.SlaveSettings
        [string]$serviceName = $slaveSettings.ServiceName
        [string]$serviceDisplayName = $slaveSettings.ServiceDisplayName
        [int]$servicePort = [int]$slaveSettings.ServicePort
        [string]$solrPath = $slaveSettings.SolrPath
        [int]$isSlave = 1
        [string]$solrMasterDNS = "$slaveSettings.SolrMasterHostname:slaveSettings.SolrMasterPort"
    
        Invoke-Expression "$PSScriptRoot\InstallAndStartSolr6Service.ps1 -serviceName $serviceName -serviceDisplayName `"$serviceDisplayName`" -servicePort $servicePort -solrPath $solrPath -Quiet $Quiet -isSlave $isSlave -solrMasterDNS $solrMasterDNS -clearHost 0"
    }
}

catch {
    Write-Error $_.Exception.Message
    Pause
}