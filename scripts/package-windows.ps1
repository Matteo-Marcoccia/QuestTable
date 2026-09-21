param(
    [string]$JavaHome = $env:JAVA_HOME,
    [string]$Maven = 'mvn',
    [string]$Version = '1.0.0'
)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
if (-not $JavaHome -or -not (Test-Path (Join-Path $JavaHome 'bin/jpackage.exe'))) {
    throw 'Set JAVA_HOME to a Windows JDK 21 installation containing jpackage.'
}
if ($Version -notmatch '^\d+\.\d+\.\d+$') {
    throw 'Use a numeric version such as 1.0.0.'
}

# Each build has its own directory; existing packages are never overwritten.
$buildId = [Guid]::NewGuid().ToString('N')
$buildRoot = Join-Path $projectRoot "target/windows-package/$buildId"
$inputDirectory = Join-Path $buildRoot 'input'
$outputDirectory = Join-Path $buildRoot 'output'
New-Item -ItemType Directory -Path $inputDirectory -Force | Out-Null
$previousJavaHome = $env:JAVA_HOME
Push-Location $projectRoot
try {
    $env:JAVA_HOME = $JavaHome
    & $Maven -B verify
    if ($LASTEXITCODE -ne 0) { throw 'Build or tests failed.' }

    & $Maven -B 'org.apache.maven.plugins:maven-dependency-plugin:3.7.0:copy-dependencies' '-DincludeScope=runtime' "-DoutputDirectory=$inputDirectory"
    if ($LASTEXITCODE -ne 0) { throw 'Could not collect runtime dependencies.' }

    Copy-Item -LiteralPath (Join-Path $projectRoot 'target/QuestTable-1.0-SNAPSHOT.jar') -Destination (Join-Path $inputDirectory 'QuestTable.jar')
    $consoleProperties = Join-Path $buildRoot 'console.properties'
    @(
        'main-class=com.questtable.main.AvvioQuestTable'
        'win-console=true'
    ) | Set-Content -LiteralPath $consoleProperties -Encoding ascii

    & (Join-Path $JavaHome 'bin/jpackage.exe') `
        --type app-image --name QuestTable --app-version $Version `
        --vendor 'Matteo Marcoccia' `
        --description 'Board Game Cafe seat reservation - academic demo' `
        --input $inputDirectory --dest $outputDirectory `
        --main-jar QuestTable.jar --main-class com.questtable.main.AvvioDemo `
        --add-launcher "QuestTable-Console=$consoleProperties"
    if ($LASTEXITCODE -ne 0) { throw 'Windows packaging failed.' }

    $appDirectory = Join-Path $outputDirectory 'QuestTable'
    Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'windows-quickstart.txt') -Destination (Join-Path $appDirectory 'START-HERE.txt')
    $zipPath = Join-Path $buildRoot "QuestTable-$Version-windows-x64.zip"
    Compress-Archive -LiteralPath $appDirectory -DestinationPath $zipPath
    (Get-FileHash -LiteralPath $zipPath -Algorithm SHA256).Hash | Set-Content -LiteralPath "$zipPath.sha256" -Encoding ascii
    Write-Host "Package ready: $zipPath"
} finally {
    Pop-Location
    $env:JAVA_HOME = $previousJavaHome
}
