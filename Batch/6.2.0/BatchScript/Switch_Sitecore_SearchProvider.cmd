@Echo Off
Set displayChoice=%1
if /I '%displayChoice%'=='' Set displayChoice=Solr
if /I '%displayChoice%'=='solr' (
  Set choice=s
) else (
  Set choice=l
  Set displayChoice=Lucene
)
Set scRootPath="C:\Sage\SitecoreSites\Sitecore8.1Imagine\Website"
Set scPath="C:\Sage\SitecoreSites\Sitecore8.1Imagine\Website\App_Config\Include"

@Echo -- Switch Sitecore to use %displayChoice% --
@Echo.
@Echo rootPath=%scPath% 
@Echo.
set /p ask="Switch Sitecore Search provider to %displayChoice%? (y/n): "
if /I %ask%==y (
  @Echo Proceed path %scPath%
  @Echo.
  powershell -file "%~dp0\Sitecore_SearchProvider_Switcher.ps1" -rootPath %scPath% -choice %choice%
  @Echo.
  @Echo Switch "global.asax" file 
  del %scRootPath%\global.asax
  copy %scRootPath%\Global%displayChoice%.asax %scRootPath%\Global.asax 

  Goto END
)

@Echo.
@Echo Operation canceled !

:END
@Echo.
::timeout /t 30
Pause

::%windir%\system32\cmd.exe /C start "Solr6Script" %cd%\BatchScript\Switch_Sitecore_SearchProvider.cmd S ^&^& exit
::%windir%\system32\cmd.exe /C start "Solr6Script" %cd%\BatchScript\Switch_Sitecore_SearchProvider.cmd L ^&^& exit