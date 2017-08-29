@Echo Off

Set ServiceName=%1
if /I '%ServiceName%'=='' Set ServiceName=Solr6
Set ServiceDisplayName=%2
if /I '%ServiceDisplayName%'=='' Set ServiceDisplayName="Solr6 Service"
Set Port=%3
if /I '%Port%'=='' Set Port=8983
Set "ServiceFullDisplayName=%ServiceDisplayName:"=% [%Port%]"
@Echo.

@Echo -- Start %ServiceName% - %ServiceFullDisplayName% --
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

call:funcCheckStartService %ServiceName%%Port% "%ServiceFullDisplayName%" %Port%

:END
goto:eof


:funcCheckStartService
    @Echo.
    @Echo # Start %1 - %2 if needed
    sc query %1 | find /i "RUNNING" > nul
    if "%ERRORLEVEL%"=="0" (
        @Echo %1 - %2 is already started, nothing to do !
        @Echo.
        timeout /t 20
    ) else (
        @Echo %1 - %2 is NOT running
        sc query %1 | find /i "PAUSED" > nul
        if "%ERRORLEVEL%"=="0" (
            @Echo %1 - %2 is paused and need to be started.
        ) else (
            @Echo %1 - %2 is NOT paused
        )

        call:funcStartService %1 %2 %3
    )
goto:eof

:funcStartService
    @Echo.
    @Echo ## Start %1 - %2
    @Echo.
    %~dp0nssm start %1
    REM net start %1
    @Echo Please waiting up to 30 to see Solr running on port %3...
    @Echo Batch is going to pause 30 sec before to continue...
    timeout /t 30 /nobreak
goto:eof