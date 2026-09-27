<#
===============================================================================
 EnterpriseDeploy
 BuildComputers.ps1
-------------------------------------------------------------------------------
 Description :
    Lit Config\Computers.csv et crée les comptes ordinateurs
    dans Active Directory.
===============================================================================
#>

Import-Module ActiveDirectory

# ============================================================================
# Configuration
# ============================================================================

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$ConfigFile  = Join-Path $ProjectRoot "Config\Computers.csv"

if (!(Test-Path $ConfigFile))
{
    Write-Host "Computers.csv introuvable." -ForegroundColor Red
    exit
}

$Computers = Import-Csv $ConfigFile

$DomainDN = (Get-ADDomain).DistinguishedName

# ============================================================================
# Création des ordinateurs
# ============================================================================

foreach ($Computer in $Computers)
{

    $OU = "$($Computer.OU),$DomainDN"

    Write-Host "Création du poste $($Computer.ComputerName)..."

    New-ADComputer `
        -Name $Computer.ComputerName `
        -SamAccountName "$($Computer.ComputerName)$" `
        -Path $OU `
        -Description $Computer.Description `
        -Enabled $true

    Write-Host "Ordinateur créé avec succès." -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================="
Write-Host "Création des ordinateurs terminée."
Write-Host "========================================="