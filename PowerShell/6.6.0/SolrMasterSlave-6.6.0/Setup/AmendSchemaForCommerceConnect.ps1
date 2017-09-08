# Setting up Sitecore Commerce Connect Solr cores
# Steps just like on http://commercesdn.sitecore.net/CS11/SitecoreCommerceConnectGuide/en-us/Task/t_EnableSOLR.html
function Create-SitecoreCommerceSolrCores()
{
    # Add field types to Solr schema file
    $schemaPath = "D:\GitHub\AlainLeconte\SolrForSitecore\PowerShell\6.6.0\SolrMasterSlave-6.6.0\SolrMasterHomeImagine\configsets\sitecore_configs_master\conf\schema-03.xml"

    $doc = [xml](Get-Content $schemaPath -Raw)

	# Check if types are already added
	
	$typeName1 = "string_ci"
	$typeName2 = "*_tm"
	$typeName3 = "*_sci"
	
	$typeName1Count = $doc.SelectNodes("//fieldType[@name='$typeName1']").Count
	$typeName2Count = $doc.SelectNodes("//dynamicField[@name='$typeName2']").Count
	$typeName3Count = $doc.SelectNodes("//dynamicField[@name='$typeName3']").Count
	
	if ($typeName1Count -eq 0)
	{
		$newFieldType = $doc.CreateElement("fieldType")
		$doc.schema.AppendChild($newFieldType) > $null
		
		$newFieldType.SetAttribute("name",$typeName1)
		$newFieldType.SetAttribute("class","solr.TextField")
		$newFieldType.SetAttribute("sortMissingLast","true")
		$newFieldType.SetAttribute("omitNorms","true")

		$newAnalyzer = $doc.CreateElement("analyzer")
		$newTokenizer = $doc.CreateElement("tokenizer")
		$newFilter = $doc.CreateElement("filter")


		$newFieldType.AppendChild($newAnalyzer) > $null
		$newAnalyzer.AppendChild($newTokenizer) > $null
		$newAnalyzer.AppendChild($newFilter) > $null

		
		$newTokenizer.SetAttribute("class","solr.KeywordTokenizerFactory")
		$newFilter.SetAttribute("class","solr.LowerCaseFilterFactory")
	}
	
	if ($typeName2Count -eq 0)
	{
		$newDynamicField1 = $doc.CreateElement("dynamicField")
		$doc.schema.AppendChild($newDynamicField1) > $null
		
		$newDynamicField1.SetAttribute("name", $typeName2)
		$newDynamicField1.SetAttribute("type", "text_general")
		$newDynamicField1.SetAttribute("indexed", "true")
		$newDynamicField1.SetAttribute("stored", "true")
		$newDynamicField1.SetAttribute("multiValued", "true")
	}
	
	if ($typeName3Count -eq 0)
	{
		$newDynamicField2 = $doc.CreateElement("dynamicField")
		
		$doc.schema.AppendChild($newDynamicField2) > $null

		$newDynamicField2.SetAttribute("name", $typeName3)
		$newDynamicField2.SetAttribute("type", "string_ci")
		$newDynamicField2.SetAttribute("indexed", "true")
		$newDynamicField2.SetAttribute("stored", "true")
	}
    
    $doc.Save($schemaPath)

}


Create-SitecoreCommerceSolrCores