# GitHub Repository Security Scanner

![PowerShell](https://img.shields.io/badge/PowerShell-script-blue)
![Python](https://img.shields.io/badge/Python-required-yellow)
![Security](https://img.shields.io/badge/Security-Scanner-red)
![License](https://img.shields.io/badge/License-MIT-green)

## Overview

This tool performs automated security scans on public GitHub repositories.

The script clones a repository locally, installs its dependencies, and runs multiple security checks to identify potential vulnerabilities or security risks. After the scan completes, the cloned repository is removed to keep the workspace clean.

Security findings are saved as structured JSON reports for later review.

---

## Security Checks

The scanner performs three types of security analysis.

### Dependency Vulnerability Scan – `pip-audit`

Checks Python dependencies for known vulnerabilities using public CVE databases.

Detects issues such as:

* vulnerable packages
* outdated libraries
* supply-chain risks

---

### Static Code Security Analysis – `Bandit`

Analyzes Python source code for insecure patterns such as:

* command injection
* unsafe subprocess usage
* weak cryptography
* insecure deserialization
* hardcoded credentials

---

### Secret Detection – `Gitleaks`

Scans repositories for exposed secrets including:

* API keys
* access tokens
* passwords
* private credentials

---

## How It Works

When the script runs, it performs the following steps:

1. Clone the target GitHub repository
2. Create an isolated Python virtual environment
3. Install security scanning tools
4. Install project dependencies (if available)
5. Run vulnerability and security scans
6. Generate JSON security reports
7. Remove the cloned repository

---

## Usage

Run the script and provide a GitHub repository URL.

Example:

```powershell
.\scan_repo.ps1 https://github.com/pallets/flask
```

The scanner will:

* clone the repository
* install dependencies
* run security scans
* generate reports

---

## Example Output

Reports are saved in the `reports` directory.

```
reports/
 └ scan_2026-03-15_14-20-31
      ├ pip-audit-report.json
      ├ bandit-report.json
      └ gitleaks-report.json
```

These JSON reports contain detailed security findings.

---

## Requirements

The following tools must be installed:

* PowerShell
* Python
* Git
* Gitleaks

Python packages used by the script:

* pip-audit
* bandit

---

## Project Purpose

This project demonstrates how automated security scanning can be used to evaluate third-party repositories before integrating them into development workflows or CI/CD pipelines.

It is intended as a simple example of security automation used in DevSecOps practices.

---

## Author

Alin 
GitHub: https://github.com/alexpedient-cloud
