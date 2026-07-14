param(
  [string]$OutputDir = (Join-Path $PSScriptRoot 'demo-screenshots'),
  [string[]]$Scenes = @('main', 'evolve', 'passive', 'switch', 'switch-detail'),
  [switch]$DryRun
)

$ErrorActionPreference = 'Stop'
$demoItem = Get-ChildItem -LiteralPath $PSScriptRoot -Filter '*demo.html' -File | Select-Object -First 1

if (-not $demoItem) { throw "Demo HTML not found in: $PSScriptRoot" }
$demoFile = $demoItem.Name
$demoPath = $demoItem.FullName

$fileNames = @{
  'main'          = '01-main.png'
  'evolve'        = '02-evolve.png'
  'passive'       = '03-passive.png'
  'switch'        = '04-switch.png'
  'switch-detail' = '05-switch-detail.png'
}

foreach ($scene in $Scenes) {
  if (-not $fileNames.ContainsKey($scene)) {
    throw "Unknown capture scene: $scene"
  }
}

$edgeCandidates = @(
  (Join-Path ${env:ProgramFiles(x86)} 'Microsoft\Edge\Application\msedge.exe'),
  (Join-Path $env:ProgramFiles 'Microsoft\Edge\Application\msedge.exe')
) | Where-Object { $_ -and (Test-Path -LiteralPath $_) }

$edge = $edgeCandidates | Select-Object -First 1
if (-not $edge) {
  $edgeCommand = Get-Command msedge -ErrorAction SilentlyContinue
  if ($edgeCommand) { $edge = $edgeCommand.Source }
}
if (-not $edge) { throw 'Microsoft Edge not found.' }

$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) { throw 'Python not found.' }

$listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, 0)
$listener.Start()
$port = ([System.Net.IPEndPoint]$listener.LocalEndpoint).Port
$listener.Stop()

$encodedFile = [Uri]::EscapeDataString($demoFile)
$baseUrl = "http://127.0.0.1:$port/$encodedFile"

if ($DryRun) {
  Write-Output "Demo: $demoPath"
  Write-Output "Edge: $edge"
  Write-Output "Output: $OutputDir"
  foreach ($scene in $Scenes) {
    Write-Output "$scene -> $($fileNames[$scene]) -> $baseUrl`?capture=$scene"
  }
  exit 0
}

New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null
$server = $null

try {
  $server = Start-Process -FilePath $python.Source `
    -ArgumentList @('-m', 'http.server', "$port", '--bind', '127.0.0.1', '--directory', $PSScriptRoot) `
    -PassThru -WindowStyle Hidden

  $ready = $false
  for ($attempt = 0; $attempt -lt 30; $attempt++) {
    try {
      Invoke-WebRequest -UseBasicParsing -Uri $baseUrl -TimeoutSec 1 | Out-Null
      $ready = $true
      break
    } catch {
      Start-Sleep -Milliseconds 100
    }
  }
  if (-not $ready) { throw 'Local preview server failed to start.' }

  foreach ($scene in $Scenes) {
    $outputPath = Join-Path $OutputDir $fileNames[$scene]
    $url = "$baseUrl`?capture=$scene"
    $edgeArgs = @(
      '--headless=new',
      '--disable-gpu',
      '--hide-scrollbars',
      '--no-first-run',
      '--window-size=1080,1920',
      '--force-device-scale-factor=1',
      '--virtual-time-budget=1500',
      "--screenshot=$outputPath",
      $url
    )
    & $edge @edgeArgs | Out-Null
    if (-not (Test-Path -LiteralPath $outputPath)) {
      throw "Screenshot failed: $scene"
    }
    Write-Output "Created: $outputPath"
  }
} finally {
  if ($server -and -not $server.HasExited) {
    Stop-Process -Id $server.Id -Force
  }
}
