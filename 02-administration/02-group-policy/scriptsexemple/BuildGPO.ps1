<#
===============================================================================
 EnterpriseDeploy
 BuildGPO.ps1
-------------------------------------------------------------------------------
 Description :
    Lit Config\GPO.csv puis crée et lie automatiquement les GPO.
===============================================================================
#>

Import-Module GroupPolicy
Import-Module ActiveDirectory

# ============================================================================
# Configuration
# ============================================================================

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$ConfigFile  = Join-Path $ProjectRoot "Config\GPO.csv"

if (!(Test-Path $ConfigFile))
{
    Write-Host "GPO.csv introuvable." -ForegroundColor Red
    exit
}

$DomainDN = (Get-ADDomain).DistinguishedName

$GPOs = Import-Csv $ConfigFile

# ============================================================================
# Création des GPO
# ============================================================================

foreach($GPO in $GPOs)
{
    Write-Host "Création de $($GPO.Name)..."

    New-GPO `
        -Name $GPO.Name `
        -Comment $GPO.Description

    $Target = "$($GPO.TargetOU),$DomainDN"

    Write-Host "Liaison avec $Target"

    New-GPLink `
        -Name $GPO.Name `
        -Target $Target `
        -LinkEnabled Yes

    Write-Host ""
}

Write-Host "========================================="
Write-Host "Toutes les GPO ont été créées."
Write-Host "========================================="