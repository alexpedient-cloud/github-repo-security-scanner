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

# Extract repo name
$folder = ($repo.Split("/")[-1]).Replace(".git","")

# Clone repository
Write-Host "Cloning repository..."
git clone $repo

# Move into repo directory
Set-Location $folder

# Create virtual environment
Write-Host "Creating Python virtual environment..."
python -m venv scan-env

# Activate virtual environment
Write-Host "Activating environment..."
.\scan-env\Scripts\activate

# Upgrade pip
python -m pip install --upgrade pip

# Install security tools
Write-Host "Installing scanning tools..."
pip install bandit pip-audit

# Install dependencies if requirements.txt exists
if (Test-Path "requirements.txt") {

    Write-Host "Installing project dependencies..."
    pip install -r requirements.txt

}
else {

    Write-Host "No requirements.txt found. Skipping dependency installation."

}

# Create report folder with timestamp
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$reportDir = "security-reports_$timestamp"

New-Item -ItemType Directory -Force -Path $reportDir | Out-Null

Write-Host ""
Write-Host "Running dependency vulnerability scan..."

pip-audit -f json | Out-File "$reportDir\pip-audit-report.json"

Write-Host "Dependency scan completed."

Write-Host ""
Write-Host "Running static code security analysis..."

bandit -r . -f json -o "$reportDir\bandit-report.json"

Write-Host "Static analysis completed."

Write-Host ""
Write-Host "Running secret detection scan..."

gitleaks detect --source . --report-format json --report-path "$reportDir\gitleaks-report.json"

Write-Host "Secret scan completed."

Write-Host ""
Write-Host "======================================="
Write-Host " Security Scan Finished"
Write-Host "======================================="

Write-Host "Reports saved in:"
Write-Host "$((Get-Location).Path)\$reportDir"

Write-Host ""
Write-Host "Generated files:"
Write-Host " - pip-audit-report.json"
Write-Host " - bandit-report.json"
Write-Host " - gitleaks-report.json"
Write-Host ""