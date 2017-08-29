param (
    [string] $rootPath,
    [string] $choice
)

Function Set-SCSearchProvider
{
    param (
        [string] $rootPath,
        [string] $choice
    )
    
    IF (!$rootPath ) {
        $rootPath = Read-Host "What is the path of your Sitecore instance's website folder?";
    } else {
        Write-Host "Sitecore Path : $rootPath" -ForegroundColor Yellow;
    }

    If (!$choice) {
        $choice = Read-Host "(L)ucene or (S)olr?";
    }

    $validInput = $true;
    #test that path is valid
    If (!(Test-Path -Path $rootPath))
    {
        Write-Host "The supplied path was invalid or inaccessible." -ForegroundColor Red;
        $validInput = $false;
    }
    #test that choice is valid
    ElseIf (($choice -ne "L") -and ($choice -ne "S"))
    {
        Write-Host "You must choose L or S." -ForegroundColor Red;
        $validInput = $false;
    }
    

    If ($validInput)
    {
        If (($choice -eq "L"))
        {
            Write-Host "Set to Lucene." -ForegroundColor Yellow;
            $selectedProvider = "Lucene";
            $deselectedProvider = "Solr";
        }
        ElseIf (($choice -eq "S"))
        {
            Write-Host "Set to Solr." -ForegroundColor Yellow;
            $selectedProvider = "Solr";
            $deselectedProvider = "Lucene";
        }

        #enumerate all config files already enabled
        $filter = "*." + $selectedProvider + ".*.config";
        $filesToEnable = Get-ChildItem -Recurse -File -Path $rootPath -Filter $filter -Exclude *.sharded.*;
        Write-Host "Enumerate all $selectedProvider config files ALREADY ENABLED ($filter)..." -ForegroundColor Green;
        foreach ($file in $filesToEnable)
        {
            Write-Host $file.Name;
        }
        Write-Host "..." -ForegroundColor Gray;

        #enumerate all config files to be enabled
        $filter = "*." + $selectedProvider + ".*.config.*";
        $filesToEnable = Get-ChildItem -Recurse -File -Path $rootPath -Filter $filter -Exclude *.sharded.*, *.config;
        Write-Host "Enumerate all $selectedProvider config files TO BE ENABLED ($filter)..." -ForegroundColor Yellow;
        foreach ($file in $filesToEnable)
        {
            Write-Host $file.Name;
            if (($file.Extension -ne ".config"))
            #if (($file.Extension -ne ".example"))
            {
                $newFileName = [io.path]::GetFileNameWithoutExtension($file.FullName);
                $newFile = Rename-Item -Path $file.FullName -NewName $newFileName -PassThru;
                Write-Host "-> " $newFile.Name -ForegroundColor Green;
            }
        }
        Write-Host "..." -ForegroundColor Gray;

        #enumerate all config files already disabled
        $filter = "*." + $deselectedProvider + ".*.config.*";
        $filesToDisable = Get-ChildItem -Recurse -File -Path $rootPath -Filter $filter -Exclude *.sharded.*, *.config;
        Write-Host "Enumerate all $deselectedProvider config files ALREADY DISABLED ($filter)..." -ForegroundColor Yellow;
        foreach ($file in $filesToDisable)
        {
            Write-Host $file.Name;
            
        }
        Write-Host "..." -ForegroundColor Gray;

        #enumerate all config files to be disabled
        $filter = "*." + $deselectedProvider + ".*.config";
        $filesToDisable = Get-ChildItem -Recurse -File -Path $rootPath -Filter $filter -Exclude *.sharded.*;
        Write-Host "Enumerate all $deselectedProvider config files TO BE DISABLED ($filter)..." -ForegroundColor Yellow;
        foreach ($file in $filesToDisable)
        {
            Write-Host $file.Name;
            if ($file.Extension -eq ".config")
            {
                $newFileName = $file.Name + ".disabled";
                $newFile = Rename-Item -Path $file.FullName -NewName $newFileName -PassThru;
                Write-Host "-> " $newFile.Name -ForegroundColor Red;
            }
        }
        Write-Host "..." -ForegroundColor Gray;
    }
}


function Pause ($Message="Press any key to continue...")
{
    Write-Host -NoNewLine $Message
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Write-Host ""
}

Set-SCSearchProvider $rootPath $choice
#Set-SCSearchProvider -rootPath C:\Sage\SitecoreSites\Include
#Read-Host "Press any key to exit..."
#Pause
#exit