[CmdletBinding()]
param(
  [string]$Reference = "docs/_reference.docx",
  [string]$Out       = "docs/_reference-altrad.docx"
)

# Always start from a fresh default reference so edits don't compound
pandoc --print-default-data-file reference.docx > $Reference
if (-not (Test-Path $Reference)) { throw "Failed to dump default reference" }

Add-Type -AssemblyName System.IO.Compression.FileSystem
$work = Join-Path $env:TEMP "pandoc_ref_$(Get-Random)"
New-Item -ItemType Directory -Path $work | Out-Null
[System.IO.Compression.ZipFile]::ExtractToDirectory((Resolve-Path $Reference), $work)

$stylesPath = Join-Path $work "word/styles.xml"
$W = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"
[xml]$xml = Get-Content $stylesPath -Raw -Encoding UTF8
$ns = New-Object System.Xml.XmlNamespaceManager($xml.NameTable)
$ns.AddNamespace("w",$W)

function Ensure-Style {
  param([string]$styleId,[string]$type="paragraph",[string]$basedOn="Normal",[string]$name="")
  $st = $xml.SelectSingleNode("//w:style[@w:styleId='$styleId']", $ns)
  if ($st) { return $st }
  if (-not $name) { $name = $styleId }
  $stylesRoot = $xml.SelectSingleNode("//w:styles", $ns)
  $newXml = "<w:style xmlns:w=`"$W`" w:type=`"$type`" w:styleId=`"$styleId`"><w:name w:val=`"$name`"/><w:basedOn w:val=`"$basedOn`"/><w:qFormat/></w:style>"
  $f = $xml.CreateDocumentFragment(); $f.InnerXml = $newXml
  [void]$stylesRoot.AppendChild($f)
  return $xml.SelectSingleNode("//w:style[@w:styleId='$styleId']", $ns)
}

function Replace-StyleProps {
  param([string]$styleId,[string]$rPrXml,[string]$pPrXml,[string]$createType="",[string]$createBasedOn="Normal")
  $st = $xml.SelectSingleNode("//w:style[@w:styleId='$styleId']", $ns)
  if (-not $st -and $createType) {
    $st = Ensure-Style $styleId $createType $createBasedOn
  }
  if (-not $st) { Write-Host "  - skip $styleId (not found)"; return }
  foreach ($n in @("rPr","pPr")) {
    $existing = $st.SelectSingleNode("w:$n", $ns)
    if ($existing) { [void]$st.RemoveChild($existing) }
  }
  if ($pPrXml) {
    $f = $xml.CreateDocumentFragment(); $f.InnerXml = $pPrXml; [void]$st.AppendChild($f)
  }
  if ($rPrXml) {
    $f = $xml.CreateDocumentFragment(); $f.InnerXml = $rPrXml; [void]$st.AppendChild($f)
  }
  Write-Host "  + $styleId styled"
}

function Run([string]$font,[int]$halfPt,[bool]$bold=$false,[string]$color="",[string]$extra="") {
  $b   = if ($bold)  { "<w:b/><w:bCs/>" } else { "" }
  $col = if ($color) { "<w:color w:val=`"$color`"/>" } else { "" }
@"
<w:rPr xmlns:w="$W">
  <w:rFonts w:ascii="$font" w:hAnsi="$font" w:cs="$font" w:eastAsia="$font"/>
  <w:sz w:val="$halfPt"/><w:szCs w:val="$halfPt"/>
  $b$col$extra
</w:rPr>
"@
}
function Para([int]$before=0,[int]$after=120,[int]$line=276,[string]$extra="") {
@"
<w:pPr xmlns:w="$W">
  <w:spacing w:before="$before" w:after="$after" w:line="$line" w:lineRule="auto"/>
  $extra
</w:pPr>
"@
}

Replace-StyleProps "Normal" (Run "Calibri" 22 $false "1A1A1A") (Para 0 120 276)
Replace-StyleProps "Title"  (Run "Calibri Light" 56 $false "E2001A") (Para 0 320 276 "<w:contextualSpacing/>")

Replace-StyleProps "Heading1" (Run "Calibri Light" 36 $false "B30015") (Para 360 120 276 "<w:keepNext/>")
Replace-StyleProps "Heading2" (Run "Calibri Light" 30 $false "B30015") (Para 320 100 276 "<w:keepNext/>")
Replace-StyleProps "Heading3" (Run "Calibri" 26 $true "333333") (Para 260  80 276 "<w:keepNext/>")
Replace-StyleProps "Heading4" (Run "Calibri" 24 $true "333333") (Para 220  60 276 "<w:keepNext/>")

Replace-StyleProps "TitleChar"    (Run "Calibri Light" 56 $false "E2001A") $null
Replace-StyleProps "Heading1Char" (Run "Calibri Light" 36 $false "B30015") $null
Replace-StyleProps "Heading2Char" (Run "Calibri Light" 30 $false "B30015") $null
Replace-StyleProps "Heading3Char" (Run "Calibri" 26 $true "333333") $null
Replace-StyleProps "Heading4Char" (Run "Calibri" 24 $true "333333") $null

Replace-StyleProps "VerbatimChar" (Run "Consolas" 20 $false "1A1A1A" "<w:shd w:val=`"clear`" w:color=`"auto`" w:fill=`"F4F4F4`"/>") $null
Replace-StyleProps "SourceCode"   (Run "Consolas" 20 $false "1A1A1A") (Para 80 80 276 "<w:shd w:val=`"clear`" w:color=`"auto`" w:fill=`"F8F8F8`"/><w:ind w:left=`"120`" w:right=`"120`"/>") "paragraph" "Normal"

Replace-StyleProps "BlockText" (Run "Calibri" 22 $false "555555" "<w:i/>") (Para 120 120 276 "<w:ind w:left=`"360`"/>")

Replace-StyleProps "FirstParagraph" (Run "Calibri" 22 $false "1A1A1A") (Para 0 120 276)
Replace-StyleProps "BodyText"       (Run "Calibri" 22 $false "1A1A1A") (Para 0 120 276)
Replace-StyleProps "Compact"        (Run "Calibri" 22 $false "1A1A1A") (Para 0  60 276) "paragraph" "Normal"
Replace-StyleProps "TOCHeading"     (Run "Calibri Light" 32 $false "B30015") (Para 240 120 276) "paragraph" "Heading1"

$tbl = $xml.SelectSingleNode("//w:style[@w:styleId='Table']", $ns)
if ($tbl) {
  $existingPr = $tbl.SelectSingleNode("w:tblPr", $ns)
  if ($existingPr) { [void]$tbl.RemoveChild($existingPr) }
  $tblXml = @"
<w:tblPr xmlns:w="$W">
  <w:tblBorders>
    <w:top    w:val="single" w:sz="6"  w:space="0" w:color="BFBFBF"/>
    <w:left   w:val="single" w:sz="6"  w:space="0" w:color="BFBFBF"/>
    <w:bottom w:val="single" w:sz="6"  w:space="0" w:color="BFBFBF"/>
    <w:right  w:val="single" w:sz="6"  w:space="0" w:color="BFBFBF"/>
    <w:insideH w:val="single" w:sz="4" w:space="0" w:color="D9D9D9"/>
    <w:insideV w:val="single" w:sz="4" w:space="0" w:color="D9D9D9"/>
  </w:tblBorders>
  <w:tblCellMar>
    <w:top    w:w="80" w:type="dxa"/>
    <w:left   w:w="100" w:type="dxa"/>
    <w:bottom w:w="80" w:type="dxa"/>
    <w:right  w:w="100" w:type="dxa"/>
  </w:tblCellMar>
</w:tblPr>
"@
  $frag = $xml.CreateDocumentFragment(); $frag.InnerXml = $tblXml
  [void]$tbl.AppendChild($frag)
  Write-Host "  + Table borders/cellmar"
}

$xml.Save($stylesPath)

if (Test-Path $Out) { Remove-Item $Out -Force }
$outAbs = (Join-Path (Resolve-Path -LiteralPath (Split-Path $Out -Parent)).Path (Split-Path $Out -Leaf))
[System.IO.Compression.ZipFile]::CreateFromDirectory($work, $outAbs)
Remove-Item -Recurse -Force $work
Write-Host "Wrote $Out ($((Get-Item $Out).Length) bytes)"
