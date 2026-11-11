# Capturas reales de pantalla (mismo estilo que las practicas)
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$Root = Split-Path $PSScriptRoot -Parent
$Out = Join-Path $Root "evidencia"
$Shots = Join-Path $Out "shots"
$bounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds

function Save-Screen([string]$name) {
  [System.Windows.Forms.Application]::DoEvents()
  Start-Sleep -Milliseconds 700
  [System.Windows.Forms.Application]::DoEvents()
  $bmp = New-Object System.Drawing.Bitmap $bounds.Width, $bounds.Height
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.CopyFromScreen($bounds.Location, [System.Drawing.Point]::Empty, $bounds.Size)
  $bmp.Save((Join-Path $Out $name), [System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose(); $bmp.Dispose()
  Write-Host "OK $name"
}

function Clean-Shot([string]$path, [int]$keep = 35) {
  if (-not (Test-Path $path)) { return "(sin archivo $path)" }
  $lines = Get-Content $path -Encoding UTF8 -ErrorAction SilentlyContinue
  $out = New-Object System.Collections.Generic.List[string]
  foreach ($line in $lines) {
    if ($line -match '\x1b\[|VERTICES|ELAPSED TIME|^INFO  :|^SLF4J:|Compiling command|Executing command|Launching Job|Starting task|Tez session|Dag name|HS2 Host|Status: Running|Subscribed to counters|Completed compiling|Completed executing|Semantic Analysis|Created Hive schema|Concurrency mode|Query ID|Total jobs|Closing:|Failed to create directory|No such file') { continue }
    $out.Add($line)
  }
  if ($out.Count -gt $keep) {
    return (($out | Select-Object -Last $keep) -join "`r`n")
  }
  return ($out -join "`r`n")
}

$form = New-Object System.Windows.Forms.Form
$form.Text = "Examen Superstore - Beeline"
$form.TopMost = $true
$form.Bounds = $bounds
$form.WindowState = "Maximized"
$form.BackColor = [System.Drawing.Color]::FromArgb(16, 20, 28)
$tb = New-Object System.Windows.Forms.TextBox
$tb.Multiline = $true
$tb.ReadOnly = $true
$tb.Dock = "Fill"
$tb.Font = New-Object System.Drawing.Font("Consolas", 14)
$tb.BackColor = [System.Drawing.Color]::FromArgb(12, 16, 22)
$tb.ForeColor = [System.Drawing.Color]::FromArgb(230, 236, 226)
$tb.ScrollBars = "Vertical"
$tb.WordWrap = $true
$form.Controls.Add($tb)
$form.Show(); $form.Activate()

function Show-Step([string]$png, [string]$title, [string]$body) {
  $tb.Text = "$title`r`n`r`n$body"
  $tb.SelectionStart = 0
  $tb.ScrollToCaret()
  $form.Activate()
  [System.Windows.Forms.Application]::DoEvents()
  Save-Screen $png
}

$docker = docker ps --filter "name=docker-hadoop-hive-parquet" --format "{{.Names}} | {{.Status}} | {{.Ports}}"
Show-Step "ex-00-docker.png" "P0 - Docker stack del repo" ($docker -join "`r`n")

Show-Step "ex-01-carga.png" "P1 - Carga / DESCRIBE / COUNT" (Clean-Shot (Join-Path $Shots "p01_carga.txt") 45)
Show-Step "ex-02-calidad.png" "P2 - Auditoria de calidad" (Clean-Shot (Join-Path $Shots "p02_calidad.txt") 30)
Show-Step "ex-03-region.png" "P3 - Evolucion por region" (Clean-Shot (Join-Path $Shots "p03_region.txt") 35)
Show-Step "ex-04-rfm.png" "P4 - Segmentacion RFM" (Clean-Shot (Join-Path $Shots "p04_rfm.txt") 35)
Show-Step "ex-05-productos.png" "P5 - Ranking productos" (Clean-Shot (Join-Path $Shots "p05_productos.txt") 35)
Show-Step "ex-06-descuentos.png" "P6 - Impacto descuentos" (Clean-Shot (Join-Path $Shots "p06_descuentos.txt") 30)
Show-Step "ex-07-tendencias.png" "P7 - Tendencias mensuales" (Clean-Shot (Join-Path $Shots "p07_tendencias.txt") 35)
Show-Step "ex-08-pareto.png" "P8 - Pareto 80/20" (Clean-Shot (Join-Path $Shots "p08_pareto.txt") 30)
Show-Step "ex-09-optimizacion.png" "Optimizacion - ORC / particiones" (Clean-Shot (Join-Path $Shots "p09_optimizacion.txt") 35)

$form.Close()
Write-Host "SHOTS_DONE"
