@Echo Off
@Echo param4=%4
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