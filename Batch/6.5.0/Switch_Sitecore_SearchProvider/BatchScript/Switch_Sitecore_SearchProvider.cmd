@Echo Off
Set displayChoice=%1
if /I '%displayChoice%'=='' Set displayChoice=Solr
if /I '%displayChoice%'=='solr' (
  Set choice=s
) else (
  Set choice=l
  Set displayChoice=Lucene
)
Set scPath="C:\Sage\SitecoreSites\Imagine.Sage\Website\App_Config\Include"

@Echo -- Switch Sitecore to use %displayChoice% --
@Echo.
@Echo rootPath=%scPath% 
@Echo.
set /p ask="Switch Sitecore Search provider to %displayChoice%? (y/n): "
if /I %ask%==y (
  @Echo Proceed path %scPath%
  @Echo.
  powershell -file "%~dp0\Sitecore_SearchProvider_Switcher.ps1" -rootPath %scPath% -choice %choice%
  goto END
)

@Echo.
@Echo Operation canceled !

:END
@Echo.
::timeout /t 30
Pause