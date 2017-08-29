@Echo Off

Set ServiceName=%1
if /I '%ServiceName%'=='' Set ServiceName=Solr6
Set ServiceDisplayName=%2
if /I '%ServiceDisplayName%'=='' Set ServiceDisplayName="Solr6 Service"
Set Port=%3
if /I '%Port%'=='' Set Port=8983
Set "ServiceFullDisplayName=%ServiceDisplayName:"=% [%Port%]"
@Echo.

@Echo -- Edit %ServiceName% - %ServiceFullDisplayName% --
@Echo current Batch path is : %~dp0
@Echo Current path is : %cd%
@Echo ServiceName: %ServiceName%
@Echo ServiceDisplayName: %ServiceDisplayName%
@Echo Port: %Port%
@Echo ServiceFullDisplayName: %ServiceFullDisplayName%
@Echo SolrBin: %cd%\%ServiceName%\bin
@Echo SolrHome: %cd%\%ServiceName%Home
@Echo.
PAUSE

@Echo # Check if "%ServiceFullDisplayName%" exists
sc query %ServiceName%%Port% >nul
if %ERRORLEVEL% EQU 1060 (
    @Echo "%ServiceFullDisplayName%" does not exists !
    @Echo.
    timeout /t 20
    goto END
) else (
    @Echo "%ServiceFullDisplayName%" exists
)

call:funcEditService %ServiceName%%Port% "%ServiceFullDisplayName%" %Port%

:END
goto:eof

:funcEditService
    @Echo.
    @Echo ## Edit %1 - %2
    @Echo.
    @Echo %~dp0nssm edit %1 ...
    %~dp0nssm edit %1
    timeout /t 30
goto:eof