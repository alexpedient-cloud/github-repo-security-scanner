param(
    [Parameter(Mandatory=$true)]
    [string]$repo
)

Write-Host ""
Write-Host "======================================="
Write-Host " GitHub Repository Security Scanner"
Write-Host "======================================="
Write-Host ""

Write-Host "Repository:" $repo

# Extract repository name
$folder = ($repo.Split("/")[-1]).Replace(".git","")

# Clone repository
Write-Host "Cloning repository..."
git clone $repo

# Move into repo directory
Set-Location $folder

# Create Python virtual environment
Write-Host "Creating Python virtual environment..."
python -m venv scan-env

# Activate environment
Write-Host "Activating environment..."
.\scan-env\Scripts\activate

# Upgrade pip
python -m pip install --upgrade pip

# Install scanning tools
Write-Host "Installing scanning tools..."
pip install bandit pip-audit

# Install project dependencies if present
if (Test-Path "requirements.txt") {

    Write-Host "Installing project dependencies..."
    pip install -r requirements.txt

}
else {

    Write-Host "No requirements.txt found. Skipping dependency installation."

}

# Create timestamp for report folder
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

# Move back to scanner root before creating report folder
Set-Location ..

# Create reports directory if it doesn't exist
New-Item -ItemType Directory -Force -Path reports | Out-Null

# Create scan-specific report folder
$reportDir = "reports\scan_$timestamp"
New-Item -ItemType Directory -Force -Path $reportDir | Out-Null

# Move back into scanned repository
Set-Location $folder

Write-Host ""
Write-Host "Running dependency vulnerability scan..."

pip-audit -f json | Out-File "..\$reportDir\pip-audit-report.json"

Write-Host "Dependency scan completed."

Write-Host ""
Write-Host "Running static code security analysis..."

bandit -r . -f json -o "..\$reportDir\bandit-report.json"

Write-Host "Static analysis completed."

Write-Host ""
Write-Host "Running secret detection scan..."

gitleaks detect --source . --report-format json --report-path "..\$reportDir\gitleaks-report.json"

Write-Host "Secret scan completed."

Write-Host ""
Write-Host "======================================="
Write-Host " Security Scan Finished"
Write-Host "======================================="

Write-Host "Reports saved in:"
Write-Host "$((Get-Location).Path)\..\$reportDir"

Write-Host ""
Write-Host "Generated files:"
Write-Host " - pip-audit-report.json"
Write-Host " - bandit-report.json"
Write-Host " - gitleaks-report.json"
Write-Host ""

# Cleanup
Write-Host "Cleaning up cloned repository..."

Set-Location ..

if (Test-Path $folder) {
    Remove-Item $folder -Recurse -Force
}

Write-Host "Temporary repository removed."
Write-Host ""
Write-Host "Scan completed successfully."