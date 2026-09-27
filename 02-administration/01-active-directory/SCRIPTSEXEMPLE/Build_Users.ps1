<#
===============================================================================
 EnterpriseDeploy
 BuildUsers.ps1
-------------------------------------------------------------------------------
 Description :
    Lit Config\Users.csv et crée les utilisateurs Active Directory.
===============================================================================
#>

Import-Module ActiveDirectory

# ============================================================================
# Configuration
# ============================================================================

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$ConfigFile  = Join-Path $ProjectRoot "Config\Users.csv"

if (!(Test-Path $ConfigFile))
{
    Write-Host "Users.csv introuvable." -ForegroundColor Red
    exit
}

$Users = Import-Csv $ConfigFile

$DomainDN = (Get-ADDomain).DistinguishedName

# ============================================================================
# Création des utilisateurs
# ============================================================================

foreach ($User in $Users)
{

    $OU = "$($User.OU),$DomainDN"

    $Password = ConvertTo-SecureString `
        $User.Password `
        -AsPlainText `
        -Force

    Write-Host "Création de $($User.SamAccountName)..."

    New-ADUser `
        -GivenName $User.FirstName `
        -Surname $User.LastName `
        -Name "$($User.FirstName) $($User.LastName)" `
        -SamAccountName $User.SamAccountName `
        -AccountPassword $Password `
        -Enabled $true `
        -Path $OU `
        -ChangePasswordAtLogon $false

    Add-ADGroupMember `
        -Identity $User.Group `
        -Members $User.SamAccountName

    Write-Host "Utilisateur créé avec succès." -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================="
Write-Host "Création des utilisateurs terminée."
Write-Host "========================================="