$GitHubUsername = "Felipevellasco"

$tmpDir = New-Item -ItemType Directory -Path (Join-Path $env:TEMP ([Guid]::NewGuid().ToString()))
try {
    $binDir = New-Item -ItemType Directory -Path (Join-Path $tmpDir "bin")

    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Error "You need Git installed on your machine to download the dotfiles repository."
        exit 1
    }

    $chezmoi = Get-Command chezmoi -ErrorAction SilentlyContinue
    if (-not $chezmoi) {
        $chezmoiPath = Join-Path $binDir "chezmoi.exe"
        Write-Host "Temporarily installing chezmoi to '$chezmoiPath'..." -ForegroundColor Cyan

        # Download and run the chezmoi windows install script
        $installScript = Invoke-RestMethod -Uri "https://get.chezmoi.io/ps1"
        Invoke-Expression $installScript

        # The default install script usually puts it in .\bin relative to current location
        # Adjusting to use the executable we just pulled
        $chezmoi = "$binDir\chezmoi.exe"
    }

    $chezmoiArgs = @()
    if (-not (Test-Path ".git")) {
        Write-Host "Initializing from remote repository..." -ForegroundColor Cyan
        $chezmoiArgs = @("init", "--apply", $GitHubUsername)
    } else {
        Write-Host "Initializing from local source..." -ForegroundColor Cyan
        # Get the current script's directory
        $scriptDir = $PSScriptRoot
        if (-not $scriptDir) { $scriptDir = Get-Location }
        $chezmoiArgs = @("init", "--apply", "--source", $scriptDir)
    }

    Write-Host "Running 'chezmoi $($chezmoiArgs -join ' ')'" -ForegroundColor Cyan
    & $chezmoi $chezmoiArgs

} finally {
    if (Test-Path $tmpDir) {
        Remove-Item -Recurse -Force $tmpDir
    }
}
