@Echo Off

Set ServiceName=%1
if /I '%ServiceName%'=='' Set ServiceName=Solr6
Set ServiceDisplayName=%2
if /I '%ServiceDisplayName%'=='' Set ServiceDisplayName="Solr6 Service"
Set Port=%3
if /I '%Port%'=='' Set Port=8983
Set "ServiceFullDisplayName=%ServiceDisplayName:"=% [%Port%]"
@Echo.

@Echo -- Stop %ServiceName% - %ServiceFullDisplayName% --
@Echo Current Batch path is : %~dp0
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
sc query %ServiceName%%Port%>nul
if %ERRORLEVEL% EQU 1060 (
    @Echo "%ServiceFullDisplayName%" does not exists !
    @Echo.
    goto END
) else (
    @Echo "%ServiceFullDisplayName%" exists
) 

call:funcStopService %ServiceName%%Port% "%ServiceFullDisplayName%" %Port%

:END
timeout /t 30
goto:eof


:funcStopService
    @Echo.
    @Echo # Stop %1 - %2 if needed
    sc query %1 | find /i "RUNNING" > nul
    if "%ERRORLEVEL%"=="0" (
        @Echo %1 - %2 is running, stop it !
        @Echo.
        @Echo ON
        REM net stop %1
        %~dp0nssm stop %1
        @Echo OFF
    ) else (
        @Echo %1 - %2 is NOT running
        sc query %1 | find /i "PAUSED" > nul
        if "%ERRORLEVEL%"=="0" (
            @Echo %1 - %2 is paused, stop it !
            @Echo.
            @Echo ON
            REM net stop %1
            %~dp0nssm stop %1
            @Echo OFF
        ) else (
            @Echo %1 - %2 is NOT paused
            @Echo nothing to do !
            @Echo.
        )
    )
goto:eof