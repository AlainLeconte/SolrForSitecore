@Echo Off

Set ServiceName=%1
if /I '%ServiceName%'=='' Set ServiceName=Solr6
Set ServiceDisplayName=%2
if /I '%ServiceDisplayName%'=='' Set ServiceDisplayName="Solr6 Service"
Set Port=%3
if /I '%Port%'=='' Set Port=8983
Set "ServiceFullDisplayName=%ServiceDisplayName:"=% [%Port%]"
Set SolrPath=%4
if /I '%SolrPath%'=='' Set SolrPath=%ServiceName%
@Echo.

@Echo -- Install %ServiceName% - %ServiceFullDisplayName% --
@Echo Current Batch path is : %~dp0
@Echo Current path is : %cd%
@Echo ServiceName: %ServiceName%
@Echo ServiceDisplayName: %ServiceDisplayName%
@Echo Port: %Port%
@Echo ServiceFullDisplayName: %ServiceFullDisplayName%
REM @Echo SolrBin: %cd%\%ServiceName%\bin
@Echo SolrBin: %cd%\%SolrPath%\bin
@Echo SolrHome: %cd%\%ServiceName%Home
@Echo.
PAUSE

@Echo # Check if "%ServiceFullDisplayName%" already exists
sc query %ServiceName%%Port% >nul
if %ERRORLEVEL% NEQ 1060 (
  @Echo "%ServiceFullDisplayName%" already exists and need to be remove
  goto REMOVE
) else (
    @Echo "%ServiceFullDisplayName%" does not exists !
)


:INSTALL
@Echo.
@Echo # Create and configure "%ServiceFullDisplayName%"
timeout /t 5
@Echo.
%~dp0nssm install %ServiceName%%Port% "%cd%\%SolrPath%\bin\solr.cmd" "start -f -p %Port% -s %cd%\%ServiceName%Home"
%~dp0nssm set %ServiceName%%Port% DisplayName "%ServiceFullDisplayName%"
%~dp0nssm set %ServiceName%%Port% Description "Script to start and stop %ServiceFullDisplayName%"
@Echo.
set /p ask="Edit "%ServiceFullDisplayName%" with NSSM UI installer? (y/n):"
if /I '%ask%'=='y' (%~dp0nssm edit %ServiceName%%Port%)
@Echo.
set /p ask="Start "%ServiceFullDisplayName%" now or not? (y/n):"
if /I '%ask%'=='y' (goto START) else goto END

:START
call:funcStartService %ServiceName%%Port% "%ServiceFullDisplayName%" %Port%
goto END

:REMOVE
set /p ask="Remove "%ServiceFullDisplayName%"? (y/n):"
if /I '%ask%' NEQ 'y' goto END
call:funcRemoveService %ServiceName%%Port% "%ServiceFullDisplayName%" %Port%
@Echo.
set /p ask=""%ServiceFullDisplayName%" has been remove continue and install new one? (y/n):"
if /I '%ask%'=='y' (goto INSTALL) else goto END

:END
timeout /t 30
goto:eof

:funcRemoveService
    @Echo.
    @Echo # Remove %2
    call:funcStopService %1 %2 %3
    @Echo ## Uninstall %2
    timeout /t 5
    %~dp0nssm remove %1 confirm
goto:eof


:funcStopService
    @Echo.
    @Echo ## Stop %2 if needed
    sc query %1 | find /i "RUNNING" > nul
    if "%ERRORLEVEL%"=="0" (
        @Echo %2 is running, stop it !
        @Echo.
        @Echo ON
        REM net stop %1
        %~dp0nssm stop %1
        @Echo OFF
    ) else (
        @Echo %2 is NOT running
        sc query %1 | find /i "PAUSED">nul
        if "%ERRORLEVEL%"=="0" (
            @Echo %2 is paused, stop it !
            @Echo.
            @Echo ON
            REM net stop %1
            %~dp0nssm stop %1
            @Echo OFF
        ) else (
            @Echo %2 is NOT paused
            @Echo nothing to do !
            @Echo.
        )
    )
goto:eof

:funcStartService
    @Echo.
    @Echo ## Start %2
    ::call:funcStopService %1 "%2" %3
    ::@Echo Batch is going to pause 10 sec before to continue...
    ::timeout /t 10 /nobreak
    @Echo.
    %~dp0nssm start %1
    REM net start %1
    @Echo Please waiting up to 30 to see Solr running on port %3...
    @Echo Batch is going to pause 30 sec before to continue...
    timeout /t 30 /nobreak
goto:eof