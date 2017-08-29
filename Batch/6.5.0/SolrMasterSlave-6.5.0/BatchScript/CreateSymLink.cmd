@Echo Off
Set SolrSlaveIntancePath=%1
if /I '%SolrMasterIntancePath%'=='' Set SolrMasterIntancePath=SolrMasterInstance
Set SolrSlaveIntancePath=%2
if /I '%SolrSlaveIntancePath%'=='' Set SolrSlaveIntancePath=SolrSlaveInstance
@Echo.

@Echo -- Create SymLink for %SolrSlaveIntancePath% from %SolrMasterIntancePath%
@Echo current Batch path is : %~dp0
@Echo Current path is : %cd%
@Echo SolrMasterInstancePath: %cd%\%SolrMasterIntancePath%
@Echo SolrSlaveInstancePath: %cd%\%SolrSlaveIntancePath%
@Echo.
PAUSE

call:createSymLink %cd%\%SolrSlaveIntancePath%\bin %cd%\%SolrMasterIntancePath%\bin
call:createSymLink %cd%\%SolrSlaveIntancePath%\bin %cd%\%SolrMasterIntancePath%\bin
call:createSymLink %cd%\%SolrSlaveIntancePath%\contrib %cd%\%SolrMasterIntancePath%\contrib
call:createSymLink %cd%\%SolrSlaveIntancePath%\dist %cd%\%SolrMasterIntancePath%\dist
call:createSymLink %cd%\%SolrSlaveIntancePath%\licenses %cd%\%SolrMasterIntancePath%\licenses

call:createSymLink %cd%\%SolrSlaveIntancePath%\server\etc %cd%\%SolrMasterIntancePath%\server\etc
call:createSymLink %cd%\%SolrSlaveIntancePath%\server\lib %cd%\%SolrMasterIntancePath%\server\lib
call:createSymLink %cd%\%SolrSlaveIntancePath%\server\modules %cd%\%SolrMasterIntancePath%\server\modules
call:createSymLink %cd%\%SolrSlaveIntancePath%\server\resources %cd%\%SolrMasterIntancePath%\server\resources
call:createSymLink %cd%\%SolrSlaveIntancePath%\server\scripts %cd%\%SolrMasterIntancePath%\server\scripts
call:createSymLink %cd%\%SolrSlaveIntancePath%\server\solr %cd%\%SolrMasterIntancePath%\server\solr
call:createSymLink %cd%\%SolrSlaveIntancePath%\server\solr-webapp %cd%\%SolrMasterIntancePath%\server\solr-webapp


timeout /t 30
goto:eof

:createSymLink
    @Echo.
    @Echo Create SymLink %1 to %2
    IF EXIST %1 (
        RD /S /Q %1
    )
    mklink /d %1 %2
goto:eof
