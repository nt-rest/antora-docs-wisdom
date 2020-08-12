& antora generate --clean playbook.yml

Copy-Item -Path ./index.html -Destination .\..\nt-rest.github.io\docs\ -Force | Out-Null
Copy-Item -Path ./CNAME      -Destination .\..\nt-rest.github.io\docs\ -Force | Out-Null
New-Item -ItemType File      -Path        .\..\nt-rest.github.io\docs\.nojekyll -Force | Out-Null

Push-Location -Path .\..\nt-rest.github.io\docs\ | Out-Null

Remove-Item -Path *.xml | Out-Null

$xmlSettings = New-Object System.Xml.XmlWriterSettings
$xmlSettings.Indent = $true
$xmlSettings.IndentChars = "  "
$xmlWriter  = [System.XML.XmlWriter]::Create(".\..\nt-rest.github.io\docs\sitemap.xml", $xmlSettings)
$xmlWriter.WriteStartDocument()
$xmlWriter.WriteStartElement("urlset", "http://www.sitemaps.org/schemas/sitemap/0.9");

$htmlBasePath = (Get-Location).Path
$htmlFilePaths = Get-ChildItem -Filter *.html -Recurse | Foreach-Object {$_.FullName}

foreach ($htmlFilePath in $htmlFilePaths)
{
  $modificationTime = ((git log -1 --format=%cs $htmlFilePath) | Out-String).Trim()
  #$modificationTime = ((git log -1 --format=%cI $htmlFilePath) | Out-String).Trim()

  $xmlWriter.WriteStartElement("url");
  $xmlWriter.WriteElementString("loc", "https://docs.nt-rest.com" + $htmlFilePath.Substring($htmlBasePath.Length).Replace("\", "/"))
  $xmlWriter.WriteElementString("lastmod", $modificationTime)
  $xmlWriter.WriteElementString("changefreq", "daily")
  $xmlWriter.WriteEndElement()
}

$xmlWriter.WriteEndElement()
$xmlWriter.WriteEndDocument()
$xmlWriter.Flush()
$xmlWriter.Close()

Pop-Location | Out-Null
