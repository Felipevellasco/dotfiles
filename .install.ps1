$GitHubUsername = "Felipevellasco"

$tools = @("git", "chezmoi")
$missingTools = @()

foreach ($tool in $tools) {
    if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
        $missingTools += $tool
    }
}

if ($missingTools.Count -gt 0) {
    foreach ($tool in $missingTools) {
        Write-Error "Error: $tool not found."
    }
    Write-Host "Please install missing dependencies using your package manager (e.g., winget or scoop) before running the script." -ForegroundColor Red
    exit 1
}

if (-not (Test-Path ".git")) {
    Write-Host "Initializing from remote repository..." -ForegroundColor Cyan
    $chezmoiArgs = @("init", "--apply", $GitHubUsername)
} else {
    Write-Host "Initializing from local source..." -ForegroundColor Cyan
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $chezmoiArgs = @("init", "--apply", "--source", $scriptDir)
}

Write-Host "Running 'chezmoi $($chezmoiArgs -join ' ')'" -ForegroundColor Cyan
& chezmoi $chezmoiArgs
